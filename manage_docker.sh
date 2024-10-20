#!/usr/bin/env bash

# Function to display usage information
usage() {
    echo "Usage: $0 -p|-r <image-name>"
    echo "  -p: Push the Docker image to Docker Hub"
    echo "  -r: Run or build the Docker image"
    exit 1
}

# Function to push Docker image to Docker Hub
push_docker_image() {
    IMAGE_NAME=$1

    # Check if logged into Docker
    if ! docker info > /dev/null 2>&1; then
        echo "You are not logged into Docker. Please run 'docker login' first."
        exit 1
    fi

    # Tag the Docker image
    if ! docker tag "$IMAGE_NAME" "yeeloman/$IMAGE_NAME:latest"; then
        echo "Failed to tag the image $IMAGE_NAME."
        exit 1
    fi

    # Push the Docker image to Docker Hub
    if ! docker push "yeeloman/$IMAGE_NAME:latest"; then
        echo "Failed to push the image $IMAGE_NAME to Docker Hub."
        exit 1
    fi

    echo "Image $IMAGE_NAME successfully pushed to yeeloman/$IMAGE_NAME:latest."
}

# Function to build and run Docker image
build_and_run_docker_image() {
    IMAGE_NAME=$1

    # Automatically rebuild the image if the Dockerfile is changed
    docker build -t "$IMAGE_NAME" .

    # Use xhost to allow local docker access to the X server
    xhost +local:docker

    # Run the docker container, mounting the current directory as a volume for persistence
    docker run -it --rm \
        -e DISPLAY="$DISPLAY" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$(pwd)":/workspace \
        "$IMAGE_NAME"
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    usage
fi

# Parse the first argument (option)
OPTION=$1
IMAGE_NAME=$2

# Handle the options
case $OPTION in
    -p)
        push_docker_image "$IMAGE_NAME"
        ;;
    -r)
        build_and_run_docker_image "$IMAGE_NAME"
        ;;
    *)
        usage
        ;;
esac
