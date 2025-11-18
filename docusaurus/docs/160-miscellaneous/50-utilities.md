# Utilities

DNS tools container for quick lookups:

```bash
kubectl run -it --rm --restart=Never --image=infoblox/dnstools:latest dnstools
```

Test firewall connectivity through a specific backend:

```bash
curl --connect-to a.example:443:x.example:443 https://a.example
```
