Build the whole platform (Authorization required)

Specify the path to `resources` folder and available GPUs (whole platform consists of 5 pods and requires 2 NVIDIA A100 - 2x40Gb VRAM) `DOCKER_GPU_IDS_1=<ID1>`, `DOCKER_GPU_IDS_2=<ID2>`... in `.env` file.

```bash
echo $COMPRESSA_DOCKER_LOGIN | docker login -u compressa --password-stdin
docker compose up --build
```

Then there will be available 5 pods:

- LLM (Default is `Qwen2.5-14B-Instruct`) - `http://localhost:8080/api/chat/`
- Embeddings (Default is `Salesforce/SFR-Embedding-Mistral`) - `http://localhost:8080/api/embeddings/`
- Rerank (Default is `BAAI/bge-reranker-base`) - `http://localhost:8080/api/rerank/`
- TTS (Default is `compressa-ai/XTTS-v2`) - `http://localhost:8080/api/tts/`
- ASR (Default is `t-tech/T-one`) - `http://localhost:8080/api/asr/`