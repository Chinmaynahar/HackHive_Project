"""Generate the missing asl_features.pkl file.

The feature column names match the ASLInput schema in app.py:
  thumb, index, middle, ring, pinky, pitch, roll
"""
import os
import joblib

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

features = ['Thumb', 'index', 'middle', 'ring', 'pinky', 'pitch', 'roll']
output_path = os.path.join(BASE_DIR, 'asl_features.pkl')
joblib.dump(features, output_path)
print(f"Created {output_path}")
print(f"Features: {features}")
