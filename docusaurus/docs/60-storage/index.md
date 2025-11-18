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
It takes a while for the ceph cluster to stabilize. 3-5 minutes from my experience.
Don't continue with the later commands until the cluster is ready.
You'll know it is ready when all pods in the `rook-ceph` namespace are `Running`.
:::

```bash
helm upgrade --install rook-ceph-cluster rook-release/rook-ceph-cluster \
--version 1.16.6 \
--namespace rook-ceph --create-namespace \
--values k8s/rook-ceph/rook-ceph-cluster-values.yaml 
```

## Enable rook orchestrator
```sh
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
ceph mgr module enable rook
ceph orch set backend rook
ceph orch status
```
Output should be
```
Backend: rook
Available: Yes
```

## Enable ceph dashboard

```bash
envsubst < k8s/rook-ceph/ceph-dashboard-ingress.yaml | kubectl apply --wait -f -
```

## Expose RGW ingress

We'll use this for syncing object stores with remote location

```bash
envsubst < k8s/rook-ceph/rgw-ingress.yaml | kubectl apply --wait -f -
```