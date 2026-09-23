# E-Commerce Kubernetes Manifests

## Architecture
Internet -> LoadBalancer -> NGINX Ingress -> {frontend-svc, backend-svc} -> postgres (StatefulSet)

## Structure
- `base/` — environment-agnostic manifests (Kustomize base)
- `overlays/{dev,staging,prod}/` — environment-specific patches
- `scripts/` — deploy & verification automation

## Deploy
    ./scripts/deploy.sh <dev|staging|prod>

## Security
- Default-deny NetworkPolicy applied cluster-wide in this namespace
- TLS via cert-manager + Let's Encrypt (prod overlay only)
- Secrets should be replaced with Sealed Secrets / Vault in real prod use
