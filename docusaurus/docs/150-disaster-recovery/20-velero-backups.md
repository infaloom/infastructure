# Velero backups

This section covers backing up k8s resources with corresponding data from PVCs. The purpose is backing up the whole namespaces for example.

## Enabling Rook-Ceph snapshot support

Official documentation:  
https://rook.io/docs/rook/v1.14/Storage-Configuration/Ceph-CSI/ceph-csi-snapshot/

Install k8s snapshot crds
```bash
kubectl kustomize https://github.com/kubernetes-csi/external-snapshotter/client/config/crd | kubectl create -f -
```

Install snapshot controller
```bash
kubectl -n kube-system kustomize https://github.com/kubernetes-csi/external-snapshotter/deploy/kubernetes/snapshot-controller | kubectl create -f -
```

Install rook-ceph VolumeSnapshotClass
```bash
kubectl apply -f https://github.com/rook/rook/raw/refs/heads/master/deploy/examples/csi/rbd/snapshotclass.yaml
```

## Velero s3 integration

Details at https://velero.io/docs/v1.17/contributions/minio/

### Install Velero CLI

Download v1.17  
```bash
wget https://github.com/vmware-tanzu/velero/releases/download/v1.17.0/velero-v1.17.0-linux-amd64.tar.gz
```

Unpack  
```bash
tar -xvf velero-v1.17.0-linux-amd64.tar.gz
```

Move binary to path  
```bash
sudo mv velero-v1.17.0-linux-amd64/velero /usr/local/bin/
```

### Configure S3 storage

Create external secret for velero. Here I reuse the same S3 credentials as for cnpg backups.
```bash
kubectl apply -f k8s/velero/cloud-credentials-external-secret.yaml
```

Create `velero` bucket at your S3 server.

Export S3_URL
```bash
export S3_URL="<REPLACE_WITH_YOUR_S3_ENDPOINT_URL>"
```

### Install Velero server
```bash
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.13.0 \
    --bucket velero \
    --no-secret \
    --backup-location-config region=,s3ForcePathStyle="true",s3Url=${S3_URL} \
    --snapshot-location-config region=,s3ForcePathStyle="true",s3Url=${S3_URL} \
    --features EnableCSI \
    --use-node-agent \
    --node-agent-disable-host-path \
    --velero-pod-mem-limit 2048Mi
```

:::note
`--velero-pod-mem-limit 2048Mi` is because backups sometimes fail because of limited pod resources. Default is 512Mi.
:::

Check version:
```bash
velero version
```
Expected output:
```bash
Client:
        Version: v1.17.0
        Git commit: 3172d9f99c3d501aad9ddfac8176d783f7692dce
Server:
        Version: v1.17.0
```

## Backup / Restore

Run test backup
```bash
velero backup create whoami-backup \
  --include-namespaces whoami \
  --snapshot-move-data \
  --exclude-resources orders.acme.cert-manager.io,challenges.acme.cert-manager.io,certificaterequests.cert-manager.io
```
Display logs
```bash
velero backup logs whoami-backup
```

Delete the namespace before restoring:
```bash
kubectl delete namespace whoami
```

Restore everything except certificates and wait for the certificates to be recreated:
```bash
velero restore create whoami-restore-no-certs \
  --from-backup whoami-backup \
  --exclude-resources certificates.cert-manager.io
```

After the auto-generated certificates are created, restore any remaining certificates:
```bash
velero restore create whoami-restore \
  --from-backup whoami-backup
```
Verify that everything is working fine.


Cleanup
```bash
velero restore delete whoami-restore-no-certs; \
velero restore delete whoami-restore; \
velero backup delete whoami-backup
```