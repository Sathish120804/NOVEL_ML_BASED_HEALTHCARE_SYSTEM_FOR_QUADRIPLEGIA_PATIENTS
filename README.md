# 🧠 NOVEL ML BASED HEALTHCARE SYSTEM FOR QUADRIPLEGIA PATIENTS

## 📌 Overview
This project presents an intelligent healthcare assistance system designed for quadriplegia patients, enabling them to communicate their needs through simple head movements. The system uses ESP32, MPU6050 sensor, and Machine Learning models to detect motion patterns and convert them into meaningful actions such as food request, emergency alert, and restroom assistance.

The system integrates IoT, Machine Learning, Mobile Application, and Cloud Computing to provide a real-time and reliable solution for patient care.

---

## 🎯 Problem Statement
Quadriplegia patients often face difficulty in communicating their needs due to limited mobility. Traditional systems are either expensive or require continuous human monitoring.

This project aims to:
- Provide independent communication
- Reduce dependency on caregivers
- Enable real-time alerts and monitoring

---

## 🚀 System Architecture

MPU6050 Sensor  
↓  
ESP32 (Transmitter)  
↓ (ESP-NOW Communication)  
ESP32 (Receiver)  
↓ (WiFi - HTTP)  
Cloud Server (Flask - Render)  
↓  
Flutter Mobile Application  
↓  
Caregiver Notification  

---

## ⚙️ Hardware Components
- ESP32 (2 Units) – Used for data acquisition and communication  
- MPU6050 Sensor – Captures accelerometer and gyroscope data  
- Power Supply (Battery/USB)  
- Optional Components:
  - Buzzer (alerts)
  - Relay (appliance control)

---

## 💻 Software Technologies

- Embedded System: Arduino (ESP32)  
- Backend: Flask (Python)  
- Cloud: Render  
- Mobile App: Flutter  
- Machine Learning: Scikit-learn  
- Data Processing: NumPy, Pandas  

---

## 🧠 Machine Learning Approach

### ✔ Type: Supervised Learning
The system uses labeled motion data to train models that classify user movements.

### 🔥 Algorithms Used
- Random Forest (Primary Model)
- Support Vector Machine (Comparison)
- Decision Tree (Baseline)

### 📊 Feature Engineering
- Raw Inputs: ax, ay, az, gx, gy, gz  
- Derived Features:
  - Acceleration Magnitude
  - Gyroscope Magnitude  

### 🔻 Dimensionality Reduction
- Linear Discriminant Analysis (LDA)
  - Converts high-dimensional data to lower dimensions
  - Improves classification performance

---

## 📈 Model Performance
- Accuracy: 96% – 99%  
- Evaluation Metrics:
  - Precision  
  - Recall  
  - F1 Score  
  - ROC AUC  
  - Confusion Matrix  
  - Sensitivity & Specificity  
  - K-Fold Cross Validation  

---

## 🌐 Cloud Server (Flask API)

### 🔹 Update Data
POST /update  

### 🔹 Get Latest Data
GET /data  

---

## 📱 Mobile Application (Flutter)

Features:
- Real-time data updates  
- Action-based UI (Food, Emergency, Restroom)  
- Color-based alert system  
- Simple and user-friendly interface  

---

## 🔗 Communication Technologies

- ESP-NOW → ESP32 to ESP32 communication  
- WiFi (HTTP) → ESP32 to Cloud  
- REST API → Cloud to Mobile App  

---

## ⚡ Advantages
- Low-cost solution  
- Real-time monitoring  
- High accuracy using Machine Learning  
- Easy deployment  
- Scalable architecture  

---

## 🏥 Real-World Applications
- Assistive healthcare systems  
- Smart hospitals  
- Elderly care monitoring  
- IoT-based patient support  

---

## 📦 Project Structure

project/
 ├── cloud_server/
 │    ├── app.py
 │    └── requirements.txt
 │
 ├── flutter_app/
 │    └── Flutter source code
 │
 ├── ml_models/
 │    ├── random_forest.ipynb
 │    ├── svm.ipynb
 │    └── dataset.xlsx
 │
 └── README.md

---

## 🚀 How to Run

### 🔹 Cloud Server
pip install -r requirements.txt  
gunicorn app:app  

### 🔹 Flutter App
flutter pub get  
flutter run  

---

## 📲 API URL (Cloud)
https://novel-ml-based-healthcare-system-for.onrender.com  

---

## 🔮 Future Enhancements
- Deep Learning models (LSTM, CNN)  
- Edge AI (Mobile as server)  
- Voice integration  
- Wearable device integration  

---

## 👨‍💻 Author
Adi Sangaran MP,Manoj Metha S,Shalini B,Sathish A
Final Year Engineering Students 
Project: Healthcare System for Quadriplegia Patients  

---

## ⭐ Conclusion
This project successfully demonstrates how Machine Learning, IoT, and Mobile Technology can be integrated to create an efficient healthcare solution for quadriplegia patients. The system ensures improved communication, faster response, and better patient care.
