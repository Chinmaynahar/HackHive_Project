from fastapi import FastAPI, HTTPException
from contextlib import asynccontextmanager
from pydantic import BaseModel
import asyncio
import joblib
import logging
import numpy as np
import os
import time
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("asl_backend")

try:
    import firebase_admin
    from firebase_admin import credentials, db
except ImportError:
    firebase_admin = None

# ================= AUTO-CLASSIFICATION LOOP =================
AUTO_POLL_INTERVAL = float(os.environ.get("AUTO_POLL_INTERVAL", "1.0"))  # seconds
AUTO_START_ON_BOOT = os.environ.get("AUTO_START", "true").lower() in ("1", "true", "yes")

auto_loop_task: asyncio.Task | None = None
auto_loop_running = False
_last_sensor_hash: str | None = None   # skip duplicate writes


async def _auto_classify_loop(
    sensor_path: str,
    output_path: str,
    interval: float,
):
    """Background loop: poll sensors → classify → write result to Firebase."""
    global auto_loop_running, _last_sensor_hash
    auto_loop_running = True
    logger.info(f"Auto-classify loop STARTED  (interval={interval}s, sensor={sensor_path}, output={output_path})")

    while auto_loop_running:
        try:
            # 1. Fetch raw sensor data
            ref  = db.reference(sensor_path)
            data = ref.get()
            if data is None or not isinstance(data, dict):
                await asyncio.sleep(interval)
                continue

            # 2. Skip if data hasn't changed
            sensor_hash = str(sorted(data.items()))
            if sensor_hash == _last_sensor_hash:
                await asyncio.sleep(interval)
                continue
            _last_sensor_hash = sensor_hash

            # 3. Classify
            sensor_values = normalize_sensor_payload(data)
            asl_input     = ASLInput(**sensor_values)
            raw           = build_input(asl_input)
            validate_array(raw, "Input")

            scaled       = scaler.transform(raw)
            validate_array(scaled, "Scaled input")

            pred_encoded = model.predict(scaled)
            pred_label   = le.inverse_transform(pred_encoded)[0]
            proba        = model.predict_proba(scaled)[0]
            confidence   = float(np.max(proba))
            ts           = int(time.time() * 1000)

            # 4. Write to Firebase
            payload = {
                "prediction":   str(pred_label),
                "confidence":   round(confidence, 4),
                "timestamp":    ts,
                "source_path":  sensor_path,
                "source_label": data.get("letter"),
                "raw_sensor":   sensor_values,
            }
            db.reference(output_path).set(payload)

            logger.info(f"Auto-classify: {pred_label} ({confidence:.2%}) → {output_path}")

        except Exception as e:
            logger.error(f"Auto-classify error: {e}")

        await asyncio.sleep(interval)

    logger.info("Auto-classify loop STOPPED")


@asynccontextmanager
async def lifespan(application: FastAPI):
    """Start the auto-classify loop when the server boots (if Firebase is ready)."""
    global auto_loop_task
    if AUTO_START_ON_BOOT and firebase_init_error is None:
        auto_loop_task = asyncio.create_task(
            _auto_classify_loop(DEFAULT_FIREBASE_PATH, DEFAULT_FIREBASE_OUTPUT_PATH, AUTO_POLL_INTERVAL)
        )
        logger.info("Auto-classify loop scheduled on startup")
    elif firebase_init_error:
        logger.warning(f"Auto-classify skipped — Firebase error: {firebase_init_error}")
    else:
        logger.info("Auto-classify disabled (AUTO_START=false)")

    yield  # app is running

    # Shutdown
    global auto_loop_running
    auto_loop_running = False
    if auto_loop_task:
        auto_loop_task.cancel()
        try:
            await auto_loop_task
        except asyncio.CancelledError:
            pass
    logger.info("Shutdown complete")


app = FastAPI(lifespan=lifespan)

# ================= LOAD ARTIFACTS =================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def load_env_file():
    env_path = Path(BASE_DIR) / '.env'
    if not env_path.exists():
        return
    for line in env_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if '=' not in line:
            continue
        key, value = line.split('=', 1)
        key   = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


load_env_file()

model        = joblib.load(os.path.join(BASE_DIR, "asl_model.pkl"))
scaler       = joblib.load(os.path.join(BASE_DIR, "asl_scaler.pkl"))
le           = joblib.load(os.path.join(BASE_DIR, "asl_label_encoder.pkl"))
FEATURE_COLS = joblib.load(os.path.join(BASE_DIR, "asl_features.pkl"))

# ================= FIREBASE INITIALIZATION =================
FIREBASE_DB_URL              = os.environ.get("FIREBASE_DATABASE_URL")
FIREBASE_CREDENTIALS_PATH    = os.environ.get("FIREBASE_CREDENTIALS_PATH")
DEFAULT_FIREBASE_PATH        = os.environ.get("FIREBASE_SENSOR_PATH",  "ASL_Glove/sensors")
DEFAULT_FIREBASE_OUTPUT_PATH = os.environ.get("FIREBASE_OUTPUT_PATH",  "ASL_Glove/processed/latest")

firebase_init_error = None
if firebase_admin is not None:
    if FIREBASE_DB_URL and FIREBASE_CREDENTIALS_PATH:
        try:
            cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred, {"databaseURL": FIREBASE_DB_URL})
        except Exception as e:
            firebase_init_error = str(e)
    else:
        firebase_init_error = (
            "Firebase not configured: set FIREBASE_DATABASE_URL and FIREBASE_CREDENTIALS_PATH."
        )
else:
    firebase_init_error = "firebase_admin package is not installed. Run `pip install firebase-admin`."

# ================= INPUT SCHEMA =================
# Keys must match what ESP32 sends — all lowercase
class ASLInput(BaseModel):
    thumb:  float
    index:  float
    middle: float
    ring:   float
    pinky:  float
    pitch:  float
    roll:   float

# ================= HELPERS =================
def build_input(data: ASLInput) -> np.ndarray:
    # Order must match FEATURE_COLS: Thumb, index, middle, ring, pinky, pitch, roll
    return np.array([[
        data.thumb, data.index, data.middle,
        data.ring,  data.pinky, data.pitch, data.roll
    ]])

def validate_array(arr: np.ndarray, label: str):
    if np.any(np.isnan(arr)) or np.any(np.isinf(arr)):
        raise HTTPException(
            status_code=422,
            detail=f"{label} contains nan or inf: {arr.tolist()}"
        )

def normalize_sensor_payload(raw_data: dict) -> dict:
    if not isinstance(raw_data, dict):
        raise HTTPException(status_code=422, detail="Raw Firebase payload must be a JSON object.")
    if "sensors" in raw_data and isinstance(raw_data["sensors"], dict):
        return raw_data["sensors"]
    return raw_data

def fetch_sensor_data_from_firebase(path: str) -> dict:
    if firebase_init_error:
        raise HTTPException(status_code=500, detail=firebase_init_error)
    ref  = db.reference(path)
    data = ref.get()
    if data is None:
        raise HTTPException(status_code=404, detail=f"No sensor data found at '{path}'")
    if not isinstance(data, dict):
        raise HTTPException(status_code=422, detail="Firebase data must be a JSON object.")
    return data

def write_processed_data_to_firebase(path: str, payload: dict):
    if firebase_init_error:
        raise HTTPException(status_code=500, detail=firebase_init_error)
    db.reference(path).set(payload)

def classify_sensor_payload(raw_data: dict) -> dict:
    sensor_data = normalize_sensor_payload(raw_data)
    try:
        data = ASLInput(**sensor_data)
    except Exception as e:
        raise HTTPException(status_code=422, detail=f"Invalid sensor payload: {e}")

    raw    = build_input(data)
    validate_array(raw, "Input")

    scaled = scaler.transform(raw)
    validate_array(scaled, "Scaled input")

    pred_encoded = model.predict(scaled)
    pred_label   = le.inverse_transform(pred_encoded)[0]
    proba        = model.predict_proba(scaled)[0]
    confidence   = float(np.max(proba))

    return {
        "prediction": str(pred_label),
        "confidence": round(confidence, 4),
        "timestamp":  int(time.time() * 1000)
    }

# ================= ROUTES =================

@app.get("/")
def home():
    return {
        "status":            "ASL Model API running",
        "model_type":        type(model).__name__,
        "classes":           le.classes_.tolist(),
        "num_classes":       len(le.classes_),
        "expected_features": FEATURE_COLS,
        "firebase_ready":    firebase_init_error is None,
    }

@app.get("/health")
def health():
    return {
        "status":         "ok",
        "model_loaded":   model is not None,
        "scaler_loaded":  scaler is not None,
        "classes":        le.classes_.tolist(),
        "firebase_ready": firebase_init_error is None,
    }

@app.post("/predict")
def predict(data: ASLInput):
    try:
        raw = build_input(data)
        validate_array(raw, "Input")

        scaled       = scaler.transform(raw)
        validate_array(scaled, "Scaled input")

        pred_encoded = model.predict(scaled)
        pred_label   = le.inverse_transform(pred_encoded)[0]
        proba        = model.predict_proba(scaled)[0]
        confidence   = float(np.max(proba))

        return {
            "prediction": str(pred_label),
            "confidence": round(confidence, 4),
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/predict/firebase")
def predict_from_firebase(path: str = DEFAULT_FIREBASE_PATH):
    raw_data       = fetch_sensor_data_from_firebase(path)
    classification = classify_sensor_payload(raw_data)
    return classification

@app.post("/predict/firebase/store")
def predict_from_firebase_and_store(
    sensor_path: str = DEFAULT_FIREBASE_PATH,
    output_path: str = DEFAULT_FIREBASE_OUTPUT_PATH,
):
    raw_data       = fetch_sensor_data_from_firebase(sensor_path)
    classification = classify_sensor_payload(raw_data)

    payload = {
        "prediction":  classification["prediction"],
        "confidence":  classification["confidence"],
        "timestamp":   classification["timestamp"],
        "source_path": sensor_path,
        "source_label": raw_data.get("letter"),
        "raw_sensor":  normalize_sensor_payload(raw_data),
    }
    write_processed_data_to_firebase(output_path, payload)

    return {"stored_at": output_path, **payload}

# ================= AUTO-LOOP CONTROL ROUTES =================

@app.post("/auto/start")
async def auto_start(
    sensor_path: str = DEFAULT_FIREBASE_PATH,
    output_path: str = DEFAULT_FIREBASE_OUTPUT_PATH,
    interval: float  = AUTO_POLL_INTERVAL,
):
    global auto_loop_task, auto_loop_running
    if auto_loop_running:
        return {"status": "already_running", "interval": interval}
    auto_loop_running = False  # ensure old loop exits
    if auto_loop_task:
        auto_loop_task.cancel()
    auto_loop_task = asyncio.create_task(
        _auto_classify_loop(sensor_path, output_path, interval)
    )
    return {"status": "started", "interval": interval, "sensor_path": sensor_path, "output_path": output_path}


@app.post("/auto/stop")
async def auto_stop():
    global auto_loop_running, auto_loop_task
    if not auto_loop_running:
        return {"status": "not_running"}
    auto_loop_running = False
    if auto_loop_task:
        auto_loop_task.cancel()
        auto_loop_task = None
    return {"status": "stopped"}


@app.get("/auto/status")
def auto_status():
    return {
        "running":       auto_loop_running,
        "interval":      AUTO_POLL_INTERVAL,
        "sensor_path":   DEFAULT_FIREBASE_PATH,
        "output_path":   DEFAULT_FIREBASE_OUTPUT_PATH,
    }


@app.post("/predict/debug")
def predict_debug(data: ASLInput):
    try:
        raw    = build_input(data)
        validate_array(raw, "Input")

        scaled   = scaler.transform(raw)
        proba    = model.predict_proba(scaled)[0]
        top3_idx = np.argsort(proba)[::-1][:3]

        return {
            "raw_input":    raw[0].tolist(),
            "scaled_input": scaled[0].tolist(),
            "feature_order": FEATURE_COLS,
            "top_3_predictions": [
                {
                    "label":      str(le.classes_[i]),
                    "confidence": round(float(proba[i]), 4),
                }
                for i in top3_idx
            ],
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
