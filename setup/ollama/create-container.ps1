param (
    [string]$Mode = "interactive"
)

# Settings
$ImageName = "aeris-llama"
$ContainerName = "aeris-llama-instance"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Build the Docker image
Write-Host "Building Docker image: $ImageName"
docker build -t $ImageName -f "$ScriptDir\Dockerfile" $ScriptDir

# Exit if build failed
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed. Aborting."
    exit 1
}

# Remove existing container if it exists
$existingContainer = docker ps -a --format '{{.Names}}' | Where-Object { $_ -eq $ContainerName }
if ($existingContainer) {
    Write-Host "Removing existing container: $ContainerName"
    docker rm -f $ContainerName | Out-Null
}

# Set run options based on mode
if ($Mode -eq "detached") {
    $RunOpts = "-d"
} elseif ($Mode -eq "interactive") {
    $RunOpts = "-it"
} else {
    Write-Host "Invalid mode: $Mode. Use 'interactive' or 'detached'."
    exit 1
}

# Run the container
Write-Host "Running Docker container ($Mode mode): $ContainerName"
docker run $RunOpts --name $ContainerName `
    -p 11434:11434 `
    -v ollama_data:/root/.ollama `
    $ImageName

# Wait for Ollama service to start
Start-Sleep -Seconds 3

# Pull the model inside the container
Write-Host "Preloading 'mistral' model inside the container..."
docker exec $ContainerName ollama pull mistral
