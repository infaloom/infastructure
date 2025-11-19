# External Secrets

Details at https://external-secrets.io/latest/introduction/getting-started/

Add helm repo and install External Secrets Operator
```bash
helm repo add external-secrets https://charts.external-secrets.io
```
```bash
helm upgrade --install external-secrets external-secrets/external-secrets \
--version 0.20.4 \
--namespace external-secrets --create-namespace
```

Create openbao-token secret
```bash
kubectl create secret generic openbao-token -n external-secrets \
--from-literal="token=$(pulumi --cwd $PULUMI_CWD config get openbao:initialRootToken)"
```

Add cluster secret store which connects to OpenBao
```bash
kubectl apply -f k8s/external-secrets/cluster-secret-store-backend.yaml
```

If you get an error:
```txt
Internal error occurred: failed calling webhook "validate.clustersecretstore.external-secrets.io": failed to call webhook: Post "https://external-secrets-webhook.external-secrets.svc:443/validate-external-secrets-io-v1-clustersecretstore?timeout=5s": no endpoints available for service "external-secrets-webhook"
```

Wait a few moments and try again.

## Example external secret
Use OpenBao CLI to create a test kv engine secret named `foo` with key `bar` and value `baz`:
```bash
kubectl exec -ti openbao-0 -n openbao -- bao kv put -mount=kv foo bar=baz
```

Sync the above external secret to the k8s secret every 1 minute:
```bash
kubectl apply -f k8s/external-secrets/example-external-secret.yaml
```

Clean up:
Delete external secret
```bash
kubectl delete -f k8s/external-secrets/example-external-secret.yaml
```
Permanently delete data & metadata secret from OpenBao
```bash
kubectl exec -ti openbao-0 -n openbao -- bao kv metadata delete -mount=kv foo
```