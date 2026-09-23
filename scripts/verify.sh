set -euo pipefail

NS=ecommerce

echo "== Pods =="
kubectl get pods -n $NS -o wide

echo "== Services =="
kubectl get svc -n $NS

echo "== Endpoints (verify selectors matched pods) =="
kubectl get endpoints -n $NS

echo "== Ingress =="
kubectl get ingress -n $NS
kubectl describe ingress ecommerce-ingress -n $NS

echo "== NetworkPolicies =="
kubectl get networkpolicy -n $NS

echo "== Connectivity Test: frontend -> backend (should succeed) =="
kubectl run tmp-test --rm -i --restart=Never --image=busybox -n $NS -- \
  wget -qO- --timeout=3 http://backend-svc.ecommerce.svc.cluster.local || echo "FAILED (expected if policy misconfigured)"

echo "== Connectivity Test: random pod -> database (should FAIL / timeout) =="
kubectl run tmp-test2 --rm -i --restart=Never --image=busybox -n $NS -- \
  nc -zv -w 3 postgres-headless.ecommerce.svc.cluster.local 5432 || echo "Correctly BLOCKED by NetworkPolicy"
