import os
import json
import time
import asyncio
import logging
from datetime import datetime, timedelta
from io import BytesIO

from fastapi import FastAPI, UploadFile, File, Depends, HTTPException, Request, BackgroundTasks
from fastapi.responses import JSONResponse, StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from tinydb import TinyDB, Query
import pandas as pd
import matplotlib.pyplot as plt
from apscheduler.schedulers.asyncio import AsyncIOScheduler

# Mocking heavy libraries to ensure it runs easily for demonstration
try:
    import torch
    import torchvision.transforms as transforms
    from PIL import Image, ImageOps
except ImportError:
    torch = None
    transforms = None
    Image = None

# ==============================================================================
# 8. SECURITY & MONITORING AGENT
# ==============================================================================
# Task: Monitor API requests and system logs, detect anomalies, log all user interactions securely
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("SecurityMonitoringAgent")

class SecurityMiddleware:
    """Security Agent that monitors all incoming requests and blocks suspicious activities."""
    async def __call__(self, request: Request, call_next):
        start_time = time.time()
        client_ip = request.client.host
        
        # Simple WAF / Anomaly detection (e.g. SQLi / XSS mock detection)
        if "select" in str(request.url).lower() or "<script>" in str(request.url).lower():
            logger.warning(f"SECURITY ALERT: Suspicious payload detected from {client_ip}")
            return JSONResponse(status_code=403, content={"detail": "Malicious payload detected"})
            
        logger.info(f"API Request: {request.method} {request.url.path} from {client_ip}")
        response = await call_next(request)
        process_time = time.time() - start_time
        logger.info(f"API Response: {response.status_code} completed in {process_time:.4f}s")
        return response

# ==============================================================================
# 2. DATA STORAGE AGENT
# ==============================================================================
# Task: Store collected data into a scalable database (Prefer NoSQL)
class DataStorageAgent:
    def __init__(self, db_path="visionsafe_nosql.json"):
        self.db = TinyDB(db_path)
        self.raw_collection = self.db.table("raw_data")
        self.processed_collection = self.db.table("processed_data")
        self.inference_collection = self.db.table("inference_logs")
        logger.info("Data Storage Agent initialized. NoSQL Database Ready.")

    def store_raw(self, data):
        self.raw_collection.insert(data)
        
    def store_processed(self, data):
        self.processed_collection.insert(data)

    def store_inference(self, data):
        self.inference_collection.insert(data)
        
    def get_all_inferences(self):
        return self.inference_collection.all()

storage_agent = DataStorageAgent()

# ==============================================================================
# 3. DATA PREPARATION AGENT
# ==============================================================================
# Task: Clean dataset, normalize and transform data. For images: resize, augment.
class DataPreparationAgent:
    def __init__(self):
        logger.info("Data Preparation Agent initialized.")

    def clean_text_data(self, raw_data):
        # Normalization and noise removal
        cleaned_data = {
            "id": raw_data.get("id"),
            "timestamp": raw_data.get("timestamp"),
            "content": str(raw_data.get("content", "")).strip().lower(),
            "source": raw_data.get("source"),
            "is_valid": len(str(raw_data.get("content", ""))) > 5
        }
        return cleaned_data

    def preprocess_image(self, image_bytes):
        if not Image:
            return image_bytes # Fallback if PIL not installed
        
        logger.info("Data Preparation Agent: Resizing and augmenting image...")
        img = Image.open(BytesIO(image_bytes)).convert("RGB")
        # Resize, Standardize and Augment (e.g., Grayscale or Normalization)
        img_resized = img.resize((224, 224))
        # Simulated tensor transformation
        if transforms:
            transform = transforms.Compose([
                transforms.ToTensor(),
                transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
            ])
            tensor_img = transform(img_resized)
            return tensor_img
        return img_resized

prep_agent = DataPreparationAgent()

# ==============================================================================
# 4. COMPUTER VISION / DEEP LEARNING AGENT
# ==============================================================================
# Task: Perform AI inference using deep learning models (TF/PyTorch)
class ComputerVisionAgent:
    def __init__(self):
        self.device = "cpu"
        # In a real scenario, we load a pretrained model here
        # self.model = torchvision.models.mobilenet_v3_small(pretrained=True)
        # self.model.eval()
        logger.info("CV/Deep Learning Agent initialized. PyTorch Backend Ready.")

    def predict(self, processed_image_tensor):
        logger.info("CV Agent: Running inference on image...")
        # Simulating Deep Learning Inference output
        # For VisionSafe, detecting "Screen Distance", "Eye Fatigue", or "Lighting Quality"
        import random
        confidence = round(random.uniform(0.75, 0.99), 4)
        
        # Simulated Bounding Box and Classification
        result = {
            "label": random.choice(["Eye Fatigue Detected", "Normal Vision", "Screen Too Close"]),
            "confidence": confidence,
            "bounding_box": [10, 20, 150, 200], # [x1, y1, x2, y2]
            "inference_time_ms": random.randint(40, 120)
        }
        return result

cv_agent = ComputerVisionAgent()

# ==============================================================================
# 1. DATA COLLECTION AGENT
# ==============================================================================
# Task: Collect data real-time with a time range, validate format, output raw JSON
class DataCollectionAgent:
    def __init__(self):
        self.is_running = False

    async def fetch_realtime_data(self):
        """Simulates fetching data from an external API with a time range (last 10 seconds)"""
        now = datetime.utcnow()
        time_range_start = now - timedelta(seconds=10)
        
        logger.info(f"Data Collection Agent: Fetching data from {time_range_start.isoformat()} to {now.isoformat()}")
        
        # Mocking an API response
        raw_payload = {
            "id": f"evt_{int(time.time())}",
            "timestamp": now.isoformat(),
            "content": "Patient reports minor eye strain after 4 hours of screen time.",
            "source": "medical_telemetry_stream"
        }
        
        # 1. Store Raw Data
        storage_agent.store_raw(raw_payload)
        
        # 2. Prepare Data
        cleaned_payload = prep_agent.clean_text_data(raw_payload)
        
        # 3. Store Processed Data
        storage_agent.store_processed(cleaned_payload)
        logger.info(f"Data Collection Agent: Successfully ingested and processed real-time data evt_{int(time.time())}")

collection_agent = DataCollectionAgent()

# ==============================================================================
# 5. ANALYTICS & VISUALIZATION AGENT
# ==============================================================================
# Task: Analyze processed data results, generate insights and statistics
class AnalyticsAgent:
    def __init__(self):
        logger.info("Analytics & Visualization Agent initialized.")

    def generate_insight_report(self):
        logger.info("Analytics Agent: Generating Insights...")
        data = storage_agent.get_all_inferences()
        if not data:
            return {"message": "No data available for analysis"}

        df = pd.DataFrame(data)
        
        # Aggregation and Big Data Analytics
        stats = {
            "total_inferences": len(df),
            "average_confidence": df['confidence'].mean() if 'confidence' in df else 0,
            "label_distribution": df['label'].value_counts().to_dict() if 'label' in df else {},
            "avg_inference_time_ms": df['inference_time_ms'].mean() if 'inference_time_ms' in df else 0
        }
        return stats

analytics_agent = AnalyticsAgent()

# ==============================================================================
# 6. API / WEB SERVICE AGENT
# ==============================================================================
# Task: Provide RESTful API endpoints for mobile app, JSON responses, secure communication
app = FastAPI(title="VisionSafe AI Big Data Pipeline", version="2.0.0")

# Apply Security Agent Middleware
@app.middleware("http")
async def security_middleware_wrapper(request: Request, call_next):
    security = SecurityMiddleware()
    return await security(request, call_next)

@app.on_event("startup")
async def startup_event():
    # Initialize the Real-Time Data Collection Scheduler
    scheduler = AsyncIOScheduler()
    scheduler.add_job(collection_agent.fetch_realtime_data, 'interval', seconds=15)
    scheduler.start()
    logger.info("Scheduler started for Real-Time Data Collection Agent.")

@app.get("/")
def root():
    return {"status": "VisionSafe AI Multi-Agent Pipeline is running."}

@app.post("/upload")
async def upload_image(file: UploadFile = File(...)):
    """Mobile App Agent sends image to this endpoint."""
    image_bytes = await file.read()
    
    # 1. Preparation Agent
    processed_tensor = prep_agent.preprocess_image(image_bytes)
    
    # 2. CV/DL Agent
    prediction = cv_agent.predict(processed_tensor)
    
    # 3. Storage Agent
    prediction_record = {
        "timestamp": datetime.utcnow().isoformat(),
        "filename": file.filename,
        **prediction
    }
    storage_agent.store_inference(prediction_record)
    
    return JSONResponse(content={"status": "success", "data": prediction_record})

@app.get("/analytics")
def get_analytics():
    """Analytics Agent endpoint."""
    report = analytics_agent.generate_insight_report()
    return JSONResponse(content={"status": "success", "report": report})

@app.get("/data/raw")
def get_raw_data():
    return {"data": storage_agent.raw_collection.all()[-10:]} # Return last 10

# ==============================================================================
# 7. MOBILE APPLICATION AGENT (Simulator)
# ==============================================================================
# Task: Consume API services, handle UI (Simulated here as an automated client)
async def mobile_app_simulator():
    """Simulates a mobile app sending data to the API periodically"""
    while True:
        await asyncio.sleep(30)
        logger.info("Mobile App Agent: App is online. Syncing with backend...")
        # Simulating API consumption
        # requests.get("http://localhost:8000/analytics")

if __name__ == "__main__":
    import uvicorn
    logger.info("Starting VisionSafe Big Data Pipeline Server...")
    # Mobile app simulator runs in background in actual deployment
    uvicorn.run(app, host="0.0.0.0", port=8000)
