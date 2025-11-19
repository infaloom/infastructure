# Provision the cloud resources

:::info
As a convenience, there is a script to export pulumi working dir and the passphrase.
```bash
source scripts/export_pulumi_env.sh
```
You can execute the above command every time you open a new terminal session to set the environment variables.

If you come across `command not found` due to line endings on WSL, you can convert the script to use Unix line endings with the following command:

```bash
sudo apt-get install dos2unix
```

```bash
dos2unix scripts/export_pulumi_env.sh
```

You can also set the environment variables manually as shown below.
:::

Export pulumi working directory
```bash
export PULUMI_CWD=$PWD/pulumi/hetzner/
```

Export pulumi passphrase. Type a strong passphrase, 16 or more characters long, and press enter.
```bash
export PULUMI_CONFIG_PASSPHRASE=$(read -s; echo $REPLY)
```

# Provision the Hetzner cloud resources

Run the following commands, __ONCE__, after initial git clone.
Note that we are using a local backend for pulumi, to avoid dependency on cloud providers.
Ideally, you would use a cloud provider to store the state, but, we are using a local backend which you can safely commit to the repository because all the secrets are encrypted.

Install pulumi packages
```bash
pulumi --cwd $PULUMI_CWD install
```

Login to pulumi with a local backend
```bash
pulumi --cwd $PULUMI_CWD login file://$PULUMI_CWD
```

Create stack with a passphrase.
```bash
pulumi --cwd $PULUMI_CWD stack init production --secrets-provider=passphrase
```

Get the hcloud token from `https://console.hetzner.cloud/projects/{REPLACE_WITH_YOUR_HETZNER_CLOUD_PROJECT_ID}/security/tokens`
```bash
pulumi --cwd $PULUMI_CWD config set --secret hcloud:token {REPLACE_WITH_YOUR_HETZNER_CLOUD_TOKEN}
```

Set the path to the ssh public key to use for the servers.
This public key will be used to access the servers. So make sure you have local ssh client setup with the corresponding private key
```bash
pulumi --cwd $PULUMI_CWD config set --secret ssh:defaultSshPublicKeyPath "{REPLACE_WITH_YOUR_SSH_PUBLIC_KEY_PATH}"
```


Set the IPv4 address you will use to manage the cluster. This is important step for security.
By default, this infrastructure will allow access to ssh port on servers only from this address.
Here is a handy command. But you can also set the IP manually.
```bash
pulumi --cwd $PULUMI_CWD config set --secret ssh:sourceIp $(curl ifconfig.me)
```
:::warning
**We assume your your IP address is static.** If your IP address changes, you'll need to re-run multiple commands to update the firewall rules, this is not covered in this guide.
:::

Create infrastructure with the following command
```bash
pulumi --cwd $PULUMI_CWD up
```
You may need to run `pulumi --cwd $PULUMI_CWD up` multiple times, depending on the resource availability in the Hetzner cloud.