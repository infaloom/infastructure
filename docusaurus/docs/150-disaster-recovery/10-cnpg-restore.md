# CloudNativePG restore

As per the documentation https://cloudnative-pg.io/documentation/1.25/recovery/ CNPG restores from the S3 backup to a new read-only cluster.

:::warning
The recovery cluster has backups disabled by default. You can enabled them in the values file.
If you enable backups. You MUST iterate on the backup bucket path on each recovery to avoid backup conflicts. `backups.s3.path`: /v1, /v2, /v3, ...
:::

```bash
envsubst < k8s/cnpg-system/cnpg-recovery-cluster-values.yaml | \
helm upgrade --install cnpg-recovery-cluster cnpg/cluster \
--version 0.2.1 \
--namespace cnpg-system \
--values -
```

## Instance promotion

Check the status of the cluster by running the command

```bash
kubectl cnpg status cnpg-recovery-cluster -n cnpg-system
```

Altough, documentation states that the is restored in read-only mode, my testing proves otherwise.
Anyway, if the recovery cluster doesn't have an instance promoted to a primary you can promote an instance with the following command:
```bash
kubectl cnpg promote cnpg-recovery-cluster cnpg-recovery-cluster-1 -n cnpg-system
```

## Clean up
Remove recovery cluster by uninstalling the chart

:::danger
This will remove the recovery cluster data as well, all PVCs will be removed.
:::

```bash
helm uninstall cnpg-recovery-cluster -n cnpg-system
```