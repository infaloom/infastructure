# Load balancer DNS
You'll need to point your cluster domain to the load balancer address.

For example, I used a wildcard domain `*.cluster.domain.tld` and pointed it to the load balancer address.
That way I can create many apps under the same domain without any DNS changes.

You can extract the load balancer address from the pulumi output:
```bash
pulumi --cwd $PULUMI_CWD stack output clusterLoadBalancer.Ipv4Address
```