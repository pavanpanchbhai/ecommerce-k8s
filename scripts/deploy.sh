set -euo pipefail

ENV=${1:-dev}   # usage: ./deploy.sh prod

echo "🚀 Deploying to environment: $ENV"

kubectl kustomize overlays/$ENV | kubectl apply --dry-run=client -f -

kubectl apply -k overlays/$ENV

echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/frontend -n ecommerce --timeout=120s
kubectl rollout status deployment/backend -n ecommerce --timeout=120s
kubectl rollout status statefulset/postgres -n ecommerce --timeout=180s

echo "✅ Deployment complete."
