# Access the K3s cluster

## Control plane high availability

To ensure high availability of the Kubernetes control plane, we will set up a load balancer using HAProxy on a separate server (serverLb) that will distribute traffic to the K3s server nodes.
```bash
ansible-playbook -i ./ansible/inventory.yaml ./ansible/playbooks/105_install_haproxy.yaml
```

## Get kubeconfig from the server

Copy kube config from server1. You run this command __ONCE__ during the initial setup.

```bash
mkdir -p ~/.kube
```

```bash
scp root@$(pulumi --cwd $PULUMI_CWD stack output server1.Ipv4Address):/etc/rancher/k3s/k3s.yaml ~/.kube/config-pulumi-hetzner-k3s
```

## Configure DNS

Execute the following command for instructions to point your DNS to the server load balancer IP
```bash
echo "Point your $K8S_URL DNS record to $(pulumi --cwd $PULUMI_CWD stack output serverLb.Ipv4Address) IP address"
```
:::info
Note that the wildcard DNS record won't work in this case because wildcard DNS points to the main load balancer IP which is used for HTTP/HTTPS traffic. Kube API server uses a different port (6443) which is handled by the server load balancer.
:::

Replace the server url in the kubeconfig file
```bash
sed -i "s#https://127.0.0.1:6443#https://${K8S_URL}:6443#g" ~/.kube/config-pulumi-hetzner-k3s
```

## Configure local kubectl
Export `KUBECONFIG` env variable to point to the above config file.
```bash
export KUBECONFIG=~/.kube/config-pulumi-hetzner-k3s
```

:::note
Optionally, you can rename the file to `config` and place it in `~/.kube/` directory. This way you don't need to export `KUBECONFIG` env variable.

```bash
mv ~/.kube/config-pulumi-hetzner-k3s ~/.kube/config
```
:::

## Verify the cluster is working

:::note
If at any point a pod gets stuck in ImagePullBackOff state it is most likely because the server's IP is blacklisted. Try deleting the affected pods and let them try to pull from the internal registry mirror.
:::

:::warning
Some resources take a while to start. Be patient and wait for the resources to stabilize.
As a rule of a thumb you can wait for all pods to become ready by executing the following command
by replacing `{deployment_namespace}` with the namespace of the deployment.
`kubectl wait --for=condition=Ready pod --all -n {deployment_namespace} --timeout=60s`

For example, to wait for all pods in the `loki` namespace to become ready you would run:
`kubectl wait --for=condition=Ready pod --all -n loki --timeout=60s`

In addition, I recommend having [k9s](https://k9scli.io/) tool where you can easily view all pods in all namespaces or a very popular desktop GUI k8s management app [Lens](https://k8slens.dev/).
:::

Ensure you are pointing to the correct cluster
```bash
kubectl get node
```

The output should be similar to:
```
NAME      STATUS   ROLES                       AGE    VERSION
agent1    Ready    <none>                      228d   v1.32.3+k3s1
agent2    Ready    <none>                      228d   v1.32.3+k3s1
agent3    Ready    <none>                      228d   v1.32.3+k3s1
server1   Ready    control-plane,etcd,master   228d   v1.32.3+k3s1
server2   Ready    control-plane,etcd,master   228d   v1.32.3+k3s1
server3   Ready    control-plane,etcd,master   228d   v1.32.3+k3s1
```