# MSSQL Server (dev/test only)

:::danger
**Not for production use!**
:::

## Generate secrets

```bash
pulumi config set --secret mssql:sa_password $(openssl rand -base64 32);
```

## Export necessary environment variables

You can copy and paste the following commands to set the environment variables.

```bash
export MSSQL_SA_PASSWORD=$(pulumi config get mssql:sa_password);
```

## Installation

Create a persistent volume claim for the MSSQL server and wait for it to be ready:

```bash
kubectl apply -f k8s/mssql/mssql-data.yaml
```

Deploy MSSQL using your environment variables for templating:

```bash
envsubst < k8s/mssql/mssql.yaml | kubectl apply -f -
```
