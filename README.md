

```
curl -X 'POST' \
  'http://localhost:6100/v1/models/add/?model_id=compressa-ai%2FLlama-3-8B-Instruct' \
  -H 'accept: application/json' \
  -d ''
```


```
curl -X 'POST' \
  'http://localhost:6101/v1/models/add/?model_id=Salesforce%2FSFR-Embedding-Mistral' \
  -H 'accept: application/json' \
  -d ''
```





curl -X 'POST' \
  'http://localhost:5500/api/chat/v1/deploy/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "model_id": "compressa-ai/Llama-3-8B-Instruct",
  "dtype": "float16"
}'


curl -X 'POST' \
  'http://localhost:5500/api/embeddings/v1/deploy/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "model_id": "Salesforce/SFR-Embedding-Mistral",
  "dtype": "float16"
}'