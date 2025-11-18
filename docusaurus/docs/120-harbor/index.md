# Harbor

https://goharbor.io/

Harbor is an open-source container image registry that secures images with role-based access control, scans images for vulnerabilities, and signs images as trusted.

## Create external secrets

Create OpenBao secret with a random password for Harbor admin user
```bash
kubectl exec -ti openbao-0 -n openbao -- bao kv put -mount=kv harbor-admin-password \
    HARBOR_ADMIN_PASSWORD=$(openssl rand -base64 32)
```

Create ExternalSecret to pull the password into k8s
```bash
kubectl apply -f k8s/harbor/harbor-admin-password-external-secret.yaml
```

Create ExternalSecret to pull the cnpg password into k8s
```bash
kubectl apply -f k8s/harbor/harbor-cnpg-password-external-secret.yaml
```

## Install

By default the harbor is configured to be served from `https://harbor.${CLUSTER_DOMAIN}` but you can change it in the `k8s/harbor/values.yaml` file.

```bash
export CLUSTER_DOMAIN=$(pulumi --cwd $PULUMI_CWD config get cluster:domain)
```

It will be accessable from the ssh source IP address you set in the pulumi config.

:::warning
Harbor has issues with Redis Sentinel support at the time of writing.
We are using the Harbor helm chart built-in redis instance.
:::

Create registry database in the PostgreSQL cluster

```bash
kubectl --namespace cnpg-system exec --stdin --tty services/cnpg-cluster-rw -- psql -c "CREATE DATABASE registry"
```

Add helm repo
```bash
helm repo add harbor https://helm.goharbor.io
```

Install Harbor with Helm
```bash
envsubst < k8s/harbor/harbor-values.yaml | \
helm upgrade --install harbor harbor/harbor \
--version 1.16.2 \
--namespace harbor --create-namespace \
--values -
```

## Pulling an image from the registry
- Change robot user prefix in Harbor Configuration to `robot-` to avoid bash issues with `robot$`.
- Create a project and robot user in the Harbor UI.

Use the following command to create a secret for the robot user in the k8s cluster.
```bash
kubectl create secret docker-registry regcred -n {namespace} --docker-server=harbor.${CLUSTER_DOMAIN} --docker-username=robot-{your robot name} --docker-password=<your-password>
```
