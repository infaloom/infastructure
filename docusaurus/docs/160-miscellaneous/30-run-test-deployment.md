# Run a test deployment

Deploy the sample `whoami` workload and scale it up for load testing or demo purposes:

```bash
envsubst < k8s/whoami/whoami.yaml | kubectl apply --wait -f - && \
kubectl scale deployment whoami-deployment -n whoami --replicas=50 && \
kubectl wait --for=create secret/whoami.${CLUSTER_DOMAIN}-tls --namespace whoami --timeout=300s && \
echo "App URL: https://whoami.${CLUSTER_DOMAIN}"
```
