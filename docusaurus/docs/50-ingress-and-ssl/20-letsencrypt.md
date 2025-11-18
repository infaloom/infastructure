# Let's Encrypt

## Environment variables
Set the email address for Let's Encrypt:
```bash
pulumi --cwd $PULUMI_CWD config set --secret letsencrypt:email {REPLACE_WITH_YOUR_EMAIL_ADDRESS}
```
Export the envrionment variables:
```bash
export LETSENCRYPT_EMAIL=$(pulumi --cwd $PULUMI_CWD config get letsencrypt:email); \
export SSH_SOURCE_IP=$(pulumi --cwd $PULUMI_CWD config get ssh:sourceIp); \
export CLUSTER_DOMAIN=$(pulumi --cwd $PULUMI_CWD config get cluster:domain)
```

## Install cert-manager

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```
Wait for cert-manager to be ready.

## Install letsencrypt issuer
:::warning
This is a production setup. Make sure you understand the implications of using letsencrypt in production.
Define proper email address in the env variable as explained above.
If you want to experiment use https://letsencrypt.org/docs/staging-environment/.
Set the appropriate letsencrypt environment in the `k8s/kube-system/letsencrypt-production.yaml` file.
:::
```bash
envsubst < k8s/kube-system/letsencrypt-production.yaml | kubectl apply -f -
```