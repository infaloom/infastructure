# Development environment

:::note
We are fixing the version of the tools used in this guide to ensure reproducibility.
:::

## Linux
**Ubuntu 24.04.1 LTS** (We used wsl on Windows)

### If running on Windows

Ensure you use `wsl` to run the commands because of the `bash` scripts.
Follow the instructions on https://learn.microsoft.com/en-us/windows/wsl/install

Install Ubuntu 24.04 distro.
```powershell
wsl --install Ubuntu-24.04 --name infastructure
```

For later use you can run it with:
```powershell
wsl -d infastructure
```

## Update list of packages
```bash
sudo apt update
```

## Git
https://git-scm.com/
```bash
sudo apt install git=1:2.43.0-1ubuntu7.3 -y
```

## .NET
https://dotnet.microsoft.com/
```bash
sudo apt install dotnet-sdk-8.0 -y
```

## Pulumi
https://www.pulumi.com/
```bash
curl -fsSL https://get.pulumi.com | sh -s -- --version 3.205.0
```

## Python
https://www.python.org/
```bash
sudo apt install python3=3.12.3-0ubuntu2.1 python3.12-venv=3.12.3-1ubuntu0.8 -y
```

### Ansible

#### Virtual environment
```bash
python3 -m venv ~/ansible-venv
```
Activate the virtual environment.
:::info
This is needed every time you open a new terminal session before using Ansible.
:::
```bash
source ~/ansible-venv/bin/activate
```

#### Install Ansible
https://docs.ansible.com/

The reason for using Ansible is to automate the setup of the K3s cluster as some commands are executed the same on multiple servers.
Where Ansible comes in handy.

Install Ansible with pip:
```bash
pip install ansible==12.2.0
```

## kubectl

https://kubernetes.io/docs/tasks/tools/install-kubectl/
```bash
sudo snap install kubectl --channel=1.32/stable --classic
```