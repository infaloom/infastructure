# Setup Ansible environment

## Generate inventory file
```sh
pulumi --cwd $PULUMI_CWD stack output --json | python ./scripts/convert_pulumi_output_to_ansible_inventory.py > ./ansible/inventory.yaml
```

You should see the message
```
Info: Host 'clusterLoadBalancer' doesn't match defined groups ('agents', 'servers'). Skipping group assignment.
```