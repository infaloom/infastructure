# Infrastructure clean up

:::danger
Ensure you understand the impact. These commands delete the resources. The actions cannot be undone.
:::

Destroy all resources during experimentation to save costs:

```bash
pulumi destroy
```

Reset the local state to the beginning and start over:

```bash
pulumi state delete --all
```
