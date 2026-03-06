FROM python:3.9-slim

WORKDIR /app

# Install dependencies inside the container
RUN pip install fastapi uvicorn pandas scikit-learn joblib

# Copy your local files into the container
COPY main.py .
COPY model.pkl .

# Expose port 8000 for the FastAPI service
EXPOSE 8000

# Start the API
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
