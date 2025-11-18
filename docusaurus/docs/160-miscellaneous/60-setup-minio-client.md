# Setup minio client for RGW

Follow the MinIO quickstart: https://min.io/docs/minio/linux/reference/minio-mc.html#quickstart

Configure an alias targeting the RGW endpoint:

```bash
mc alias set $BUCKET_NAME $ https://rgw.${CLUSTER_DOMAIN} $S3_ACCESS_KEY_ID $S3_SECRET_ACCESS_KEY
```
