# Deploy Platform

Pull images

```shell
compressa/compressa-pod:0.3.10
compressa/compressa-entrypoint:0.3.10
compressa/compressa-autotest:0.3.10
compressa/compressa-layout-gpu:0.3.10
compressa/compressa-ui:0.3.10
compressa/compressa-auth:0.3.10
nginx:latest
opensearchproject/opensearch:2.13.0
opensearchproject/opensearch-dashboards:2.13.0
opensearchproject/data-prepper:2.6.0
```


### Resources

Folders with data and models are currently mounted to docker container from the host machine.

Add necessary folders permissions for Docker.

To change their location, edit `RESOURCES_PATH` and `HF_HOME` variable in `.env` files:

```shell
# file: deploy/pod/.env
RESOURCES_PATH=/data/shared/CompressaAI/<DEPLOY>
DATASET_PATH=<FOLDER FOR LOADED DATASETS (USED FOR FINE TUNING ONLY)>
HF_HOME=/data/shared/CompressaAI/<FOLDER>
...
```

`DEPLOY` folder structure:

```
DEPLOY  
│
└─models
│ │
│ └─models

```

1. Change access: `chmod -R 777 build`, `chmod -R 777 test_results`, `chmod -R 777 data-prepper`
2. Create common Docker network: `docker network create test_network`
3. Edit the config: `build/config.yaml`
4. Root directory: `cd deploy/platform`
5. Load environment variables
```bash
set -a
source .env
set +a
```
6. Run dispatcher `docker compose up`
7. The dispatcher generates `deploy/platform/build/auto.yaml` file according to requested number of pods
8. Run the generated docker compose file: `docker compose -f ./build/auto.yaml up`
9. Pods and dispatcher will be available at `http://localhost:8118/`
10. Nginx will be available at `http://localhost:9999/` (authorization required, refer to [Auth service manual](https://github.com/compressa-ai/app/blob/main/services/auth/README.md))
11. UI for chat - `http://localhost:9999/chat/` and layout `http://localhost:9999/ui-layout/` will be available in the browser.
12. OpenSearch Dashboard will be available at `http://localhost:5602/` (not connected to Nginx).

It is possible to edit Platforms `docker-compose.yaml` file to run Layout Model on GPU

```yaml
# .env
...
LAYOUT_RESOURCES_PATH=/data/shared/CompressaAI/<DEPLOY>
NETWORK=test_network
PROJECT=dev
PORT=8100
LAYOUT_GPU_IDS=2
...
```

```yaml
...
  unstructured-api:
    environment:
      - LAYOUT_RESOURCES_PATH=${LAYOUT_RESOURCES_PATH:-./resources} # somewhere in RESOURCES_PATH
      - PROJECT=${PROJECT:-compressa}
      - PIPELINE_PACKAGE=${PIPELINE_PACKAGE:-general}
    container_name: ${PROJECT:-compressa}-unstructured-api
    volumes:
      - ${LAYOUT_RESOURCES_PATH:-./resources}:/home/notebook-user/.cache
    ports:
      - ${PORT:-8100}:8000
    deploy:
      resources:
        reservations:
          devices:
          - capabilities:
            - gpu
            device_ids:
            - ${LAYOUT_GPU_IDS:-0}
            driver: nvidia
    image: compressa/compressa-layout-gpu:0.3.9
    restart: always
    shm_size: 32g
    networks:
      - ${NETWORK:-common_network}
...
```

Then the Layout Model will be available with Nginx but not connected to Dispatcher.

---

# Deploy Pod

### Deploy only one compressa-pod instance
1. Edit `deploy-config.json` file.
2. Run Compressa (only one instance)
   ```bash
   cd deploy/pod
   set -a
   source .env
   set +a
   docker compose up compressa-pod -d
   ```

The model will be available at `http://localhost:5000` and the service endpoints - at port `http://localhost:5100`.

### Configs

In config files the model engine and parameters can be specified, e.g.

```json
{
  "model_id": "mixedbread-ai/mxbai-embed-large-v1",
  "served_model_name": "Compressa-Embedding",
  "dtype": "float16",
  "backend": "vllm",
  "task": "embeddings"
}

```

### Chat (For LLM Pod only)

Run 
```bash
cd deploy/pod
set -a
source .env
set +a
docker compose up compressa-pod compressa-client-chat -d
```

Chat UI will be available in browser at `http://localhost:8501/chat`
