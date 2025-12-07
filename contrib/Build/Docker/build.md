## Build Docker Image

```
docker buildx build --platform linux/amd64,linux/arm64 --target runtime --provenance=mode=max --attest type=sbom,kind=image -t ghcr.io/internationalcolorconsortium/iccdev:latest --load --push .
```
