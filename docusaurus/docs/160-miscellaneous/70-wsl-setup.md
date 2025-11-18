# WSL Setup

https://learn.microsoft.com/en-us/windows/wsl/install

:::note
When updating WSL version with `wsl --update`, you may need to reinstall Docker Desktop and restart your computer to complete the update.
:::

## Install additional Linux distributions

It may be useful to install additional Linux distributions if you want to manage multiple environments to avoid conflicts between projects.

To create a new WSL instance with Ubuntu 24.04 named Ubuntu2, run the following command in PowerShell:
```powershell
wsl --install Ubuntu-24.04 --name Ubuntu2
```