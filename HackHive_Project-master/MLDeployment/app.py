from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np

app = FastAPI()

# ✅ Load all three artifacts at startup
model = joblib.load("asl_model (1).pkl")
scaler = joblib.load("asl_scaler.pkl")
le = joblib.load("asl_label_encoder.pkl")
FEATURE_COLS = joblib.load("asl_features.pkl")

# ✅ Typed input model — prevents missing/wrong-order features
class ASLInput(BaseModel):
    f1: float
    f2: float
    f3: float
    f4: float
    f5: float
    pitch: float
    roll: float

@app.get("/")
def home():
    return {
        "message": "ASL Model API running",
        "expected_features": FEATURE_COLS,
        "classes": le.classes_.tolist()
    }

@app.post("/predict")
def predict(data: ASLInput):
    try:
        # ✅ Build array in exact training order
        raw = [[data.f1, data.f2, data.f3, data.f4, data.f5, data.pitch, data.roll]]

        # ✅ Apply same scaler used during training
        scaled = scaler.transform(raw)

        # ✅ Predict and decode label
        pred_encoded = model.predict(scaled)
        pred_label = le.inverse_transform(pred_encoded)[0]

        # Confidence scores
        proba = model.predict_proba(scaled)[0]
        confidence = float(np.max(proba))

        return {
            "prediction": pred_label,
            "confidence": round(confidence, 4)
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

# Debug endpoint — remove in production
@app.post("/predict/debug")
def predict_debug(data: ASLInput):
    raw = [[data.f1, data.f2, data.f3, data.f4, data.f5, data.pitch, data.roll]]
    scaled = scaler.transform(raw)
    proba = model.predict_proba(scaled)[0]
    top3_idx = np.argsort(proba)[::-1][:3]

    return {
        "raw_input": raw[0],
        "scaled_input": scaled[0].tolist(),
        "top_3_predictions": [
            {"label": le.classes_[i], "confidence": round(float(proba[i]), 4)}
            for i in top3_idx
        ]
    }