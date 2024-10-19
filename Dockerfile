FROM python:3.11-slim

# Install essential build tools and OpenCV dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopencv-dev \
    python3-opencv \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python libraries (e.g., MediaPipe, OpenCV, NumPy)
RUN pip install mediapipe opencv-python numpy

# Create a workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace
