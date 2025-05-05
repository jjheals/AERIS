# AERIS
Automated Extraction and Recon from Internet Sources (AERIS): An OSINT automation system for real-time data collection, textual analysis, and data-driven insight powered by machine learning and artificial intelligence.

# Setup 

This application runs an Ollama model (minstral) and a Postgres database in two separate docker containers, with an intermediate API using Flask (python) and an Electron (JS) frontend. To setup the application, you must: 

1. Create the Ollama container
2. Create the Postgres container
3. Install the required python dependencies 
4. Install the required Node dependencies (Electron/JS)

## Ollama Setup

This section will walk through how to setup and start the Ollama docker container.

### Create Docker Container 

To create and start the Ollama docker container, you can use the bash or powershell script (depending on your system) located in the [setup/](./setup/) folder: 

```bash
# Linux/Unix/MacOS
cd setup
./create-ollama-container.sh
```

```bash
# Windows
cd setup
.\create-ollama-container.ps1
``` 

The scripts also accept one argument for "mode": 

- **Mode "interactive"** (default): launch the docker container in the current shell and print outputs here.
- **Mode "detached"**: launch the docker container in the background (headless). 

To use: 

```bash
# Linux/Unix/MacOS
./create-ollama-container.sh --mode detached
```

```bash
# Windows
.\create-ollama-container.ps1 -Mode detached 
```

### Verify Container

You can verify that the docker container was created successfully by going to http://localhost:11434/api/tags/ in a web browser. 

If you do *not* see any models listed, try running the following command in your terminal to list the available models: 

```bash
docker exec -it aeris-llama-instance ollama list
```

If you see an empty table, that likely means that the script failed to pull the minstral model. In the same terminal, run the following line: 

```bash
docker exec -it aeris-llama-instance ollama pull mistral
```

This will pull the minstral model. If this fails, try restarting from scratch. 

Verify by visiting the same url (http://localhost:11434/api/tags/) and you should see something like: 

```json
{
  "models": [
    {
      "name": "mistral:latest",
      "model": "mistral:latest",
      "modified_at": "2025-05-05T03:09:04.803041392Z",
      "size": 4113301824,
      "digest": "f974a74358d62a017b37c6f424fcdf2744ca02926c4f952513ddf474b2fa5091",
      "details": {
        "parent_model": "",
        "format": "gguf",
        "family": "llama",
        "families": [
          "llama"
        ],
        "parameter_size": "7.2B",
        "quantization_level": "Q4_0"
      }
    }
  ]
}
```

### Future Runs

Once you've created the Ollama container, for future runs, you can use the convenience scripts in the [run/](./run/) folder to start the container. Note that these scripts are purely for convenience and will only run the container in the background, and they do not accept "mode" arguments.

```bash
# Linux/Unix/MacOS
cd run/ollama/
./start-ollama.sh
```

```bash
# Windows
cd run/ollama/ 
.\start-ollama.ps1
```

If you're using Docker Desktop, you can start the container from there too - look for the "aeris-llama-container" container name. 

## Postgres Setup


## Python Dependencies


## Node Modules