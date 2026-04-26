from flask import Flask, request, jsonify
import time
import os
import numpy as np
import joblib

app = Flask(__name__)

# Load ML model (optional)
try:
    model = joblib.load("rf_model.pkl")
    scaler = joblib.load("scaler.pkl")
    lda = joblib.load("lda.pkl")
    labels = ["FOOD", "RESTROOM", "EMERGENCY", "ELECTRICAL"]
    ML_ENABLED = True
except:
    ML_ENABLED = False

latest_data = {
    "value": "0,NONE",
    "time": time.time()
}

def predict(ax, ay, az, gx, gy, gz):
    acc_mag = (ax**2 + ay**2 + az**2)**0.5
    gyro_mag = (gx**2 + gy**2 + gz**2)**0.5

    sample = np.array([[ax, ay, az, gx, gy, gz, acc_mag, gyro_mag]])

    sample = scaler.transform(sample)
    sample = lda.transform(sample)

    pred = model.predict(sample)[0]
    return pred, labels[int(pred)]

# =========================
@app.route('/update', methods=['POST'])
def update():
    global latest_data

    try:
        data = request.get_json(force=True)

        # If ML enabled
        if ML_ENABLED and "ax" in data:
            pred, action = predict(
                float(data["ax"]),
                float(data["ay"]),
                float(data["az"]),
                float(data["gx"]),
                float(data["gy"]),
                float(data["gz"])
            )
            latest_data["value"] = f"{pred},{action}"

        else:
            latest_data["value"] = data.get("value", "0,NONE")

        latest_data["time"] = time.time()

        print("✅ Updated:", latest_data)

        return jsonify({"status": "ok"})

    except Exception as e:
        print("❌ Error:", str(e))
        return jsonify({"error": "server error"}), 500

# =========================
@app.route('/data')
def get_data():
    return jsonify(latest_data)

@app.route('/')
def home():
    return "Server Running 🚀"

# =========================
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    app.run(host="0.0.0.0", port=port)
