FROM python:3.11-slim AS builder

# 1. Install essential build tools and OpenCV dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    libopencv-dev \
    python3-opencv \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Set the working directory
WORKDIR /workspace

# 3. Install Python dependencies separately to cache them
# Copy only requirements.txt to avoid invalidating this layer unnecessarily
COPY requirements.txt /workspace/requirements.txt

# 4. Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# 5. Now copy the rest of the application files (code, assets, etc.)
COPY . /workspace

# 6. Set default command (if needed)
CMD ["/bin/bash"]

