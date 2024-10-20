FROM python:3.11-slim AS builder

# Install essential build tools and OpenCV dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libopencv-dev \
    python3-opencv \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries (e.g., MediaPipe, OpenCV, NumPy)
RUN pip install --no-cache-dir mediapipe opencv-python numpy

# Create a workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Copy files from host
COPY . /workspace
