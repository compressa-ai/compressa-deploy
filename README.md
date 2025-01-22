## Chart

`compressa-platform` directory contains helm chart for main Compressa components.

## Other services

`standalone-services` contains manifests for external services, that are not part of Compressa.

Currently it only contains manifests for minio.

**These manifests are not intended for production deployment!** They are provided to speed up
initial deployment for testing purposes, and do not follow best practices. Please, read the
documentation, provided by the developers of those products prior to deploying them.
