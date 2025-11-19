# Storage

## Add Rook Helm repo

```bash
helm repo add rook-release https://charts.rook.io/release
```

## Install Rook Ceph

https://rook.io/docs/rook/latest-release/Helm-Charts/operator-chart/#installing

Install rook-ceph operator
```bash
helm upgrade --install rook-ceph rook-release/rook-ceph \
--version 1.16.6 \
--namespace rook-ceph --create-namespace \
--values k8s/rook-ceph/rook-ceph-operator-values.yaml
```

Install ceph cluster
:::note
It takes a while for the ceph cluster to stabilize. 5-6 minutes from my experience.
Don't continue with the later commands until the cluster is ready.

```bash
kubectl --namespace rook-ceph get cephcluster
```
PHASE should be `Ready`.
:::

```bash
helm upgrade --install rook-ceph-cluster rook-release/rook-ceph-cluster \
--version 1.16.6 \
--namespace rook-ceph --create-namespace \
--values k8s/rook-ceph/rook-ceph-cluster-values.yaml 
```

## Enable rook orchestrator
```bash
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
```
```bash
ceph mgr module enable rook
ceph orch set backend rook
ceph orch status
```
Output should be
```
Backend: rook
Available: Yes
```

Then manually disable ssl on manager because this isn't properly picked up by default
```bash
ceph config set mgr mgr/dashboard/ssl false
```

## Enable ceph dashboard

```bash
envsubst < k8s/rook-ceph/ceph-dashboard-ingress.yaml | kubectl apply --wait -f -
```
Run this to get the admin password
```bash
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo
```

Run the following command to get the dashboard URL
```bash
echo "Access the dashboard at https://ceph-dashboard.${CLUSTER_DOMAIN}"
echo "Username: admin"
echo "Password: $(kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode)"
```

## Expose RGW ingress

Optional: If you want to expose the S3 compatible RGW endpoint via ingress, run the following command:
```bash
envsubst < k8s/rook-ceph/rgw-ingress.yaml | kubectl apply --wait -f -
```