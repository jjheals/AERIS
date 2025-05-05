#!/bin/bash

set -e

# Default settings
IMAGE_NAME="aeris-llama"                # Name of the image to be created
CONTAINER_NAME="aeris-llama-instance"   # Name of the container to be created
MODE="interactive"                      # Default mode (interactive)

# Parse --mode flag
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter passed: $1"
            echo "Usage: $0 [--mode interactive|detached]"
            exit 1
            ;;
    esac
done

# Build the docker image from the current directory (setup/)
echo "Building Docker image: $IMAGE_NAME"
if ! docker build -t "$IMAGE_NAME" -f Dockerfile .; then
  echo "Docker build failed. Aborting."
  exit 1
fi

# Remove the existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
  echo "Removing existing container: $CONTAINER_NAME"
  docker rm -f "$CONTAINER_NAME"
fi

# Determine Docker run options
if [[ "$MODE" == "detached" ]]; then
    RUN_OPTS="-d"
elif [[ "$MODE" == "interactive" ]]; then
    RUN_OPTS="-it"
else
    echo "Invalid mode: $MODE. Use 'interactive' or 'detached'."
    exit 1
fi

# Run the container
echo "Running Docker container ($MODE mode): $CONTAINER_NAME"
docker run $RUN_OPTS --name "$CONTAINER_NAME" \
  -p 11434:11434 \
  -v ollama_data:/root/.ollama \
  "$IMAGE_NAME"

# Wait for the Ollama server to initialize
echo "Waiting for Ollama to start..."
sleep 3

# Preload the mistral model
echo "Pulling 'mistral' model inside the container..."
if ! docker exec "$CONTAINER_NAME" ollama pull mistral; then
  echo "Failed to pull 'mistral' model. Make sure the container is running and Ollama is responding."
  exit 1
fi

# Success
echo "Setup complete. Ollama with 'mistral' model is ready."
