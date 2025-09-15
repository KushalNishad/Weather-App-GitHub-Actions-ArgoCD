# syntax=docker/dockerfile:1
FROM python:3.11-slim

# Basics for predictable Python behavior
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Use a venv (no root-pip warning) and put it on PATH
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Optional: system deps if you build wheels (uncomment if needed)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential gcc \
#   && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install deps first to leverage Docker cache
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app
COPY . .

# app should listen on 0.0.0.0:5000
EXPOSE 5000

# Drop privileges
RUN useradd -m app
USER app

# Start the app
CMD ["python", "app.py"]