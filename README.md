# Overview

## Chart

`compressa-platform` directory contains helm chart for main Compressa components.

## Other services

`standalone-services` contains manifests for external services, that are not part of Compressa.

Currently it only contains manifests for minio.

**These manifests are not intended for production deployment!** They are provided to speed up
initial deployment for testing purposes, and do not follow best practices. Please, read the
documentation, provided by the developers of those products prior to deploying them.

# How to deploy

## Requirements

- Kubernetes cluster
- NVIDIA device plugin or some other compatible plugin
- `kubectl` and `helm` on your machine
- Operational PV provisioner (or you'll need to create a PV manually)

## Quickstart Guide

1. Install `minio`

If you are installing for testing purposes, you can use the manifest from this repository:

```
kubectl apply -f standalone-services/minio-dev.yaml
```

2. Create a secret `compressa-registry-credentials` with the credentials for docker registry access

```
kubectl create secret docker-registry compressa-registry-credentials --docker-server="https://index.docker.io/v1/" --docker-username=compressa --docker-password=123456
```

3. Install Compressa: 

```
helm install compressa compressa-platform
```

## Configuration

### Common overrides

Some important values you will probably want or need to change

- **PVC options**: Defined in `common.volumes`. You might need to change access mode to `ReadWriteMany` in a multinode cluster.
- **Minio credentials**: default value is suitable for minio deployed using the manifest included. Change to something proper in production. N.B.: Compressa only needs minio admin access to create buckets, consider creating them manually and configuring a non-privileged user access.
- **Served models**: config files are defined in `worker_configmap` and mounted into pods
- **Rerank model**: see `rerank.args`
- **Runtime class name**: defaults to `nvidia` for GPU pods and not defined for other pods
- **Pod probe timeouts**: adjust to your needs if pods enter restart loops due to long model deployment times
- **Pod internal DNS name** (for client WebUI): see `client.instances.(name).env`, change according to your *release name* (default value assumes that it is `compressa` like in command above)
- **Ingress domain**: set in `ingress.host`

### MIG, HAMi etc

To use MIG, make sure that your `nvidia-device-plugin` is configured with `migStrategy="mixed"` and successfully detects your GPU partitions. After that, just change pod resources (e.g. `nvidia.com/mig-4g.20gb: 1` instead of `nvidia.com/gpu: 1`)

To use HAMi, add annotations to `podAnnotations` (e.g. `hami.io/gpu-scheduler-policy: binpack`) and edit pod resources (e.g. `nvidia.com/gpumem: 30720`)

**Known issues**: 

- Deployment with MIG does not work with Compressa version `0.3.3`, version `0.3.4` needs testing.
- pod-1 (LLM) crashes with CUDA OOM error when using HAMi and NVIDIA A100 40Gb (might be fixed with tweaking pod memory limits, further testing required)
