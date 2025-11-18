# <ins>Infa</ins>loom Infra<ins>structure</ins> -> <ins>Infastructure</ins>

Easy to follow DIY Kubernetes cluster guide, combining Ansible host prep, Pulumi resource provisioning, and Kubernetes add-ons. Most of the guidance lives in the docs site — this README only sketches the highlights.

## Documentation

- Primary reference: [https://infaloom.github.io/infastructure/](https://infaloom.github.io/infastructure/)
- Key sections include:
	- **Introduction & roadmap** – context, guiding principles, and near-term plans.
	- **Getting started** – workstation setup, secrets management, and required credentials.
	- **Cloud provisioning** – Pulumi-driven Hetzner automation plus inventory export into Ansible.
	- **K3s cluster operations** – bootstrap, scale-out, ingress/SSL, and storage guidance.
	- **Platform services** – Harbor, CNPG, Redis, Argo CD, secret management, monitoring, logging, and disaster recovery runbooks.

If something feels missing, file an issue or contribute directly under `docusaurus/docs`.

## Repository layout

- `pulumi/` – infrastructure stacks and helper scripts.
- `ansible/` – host initialization, k3s install, and supporting playbooks.
- `k8s/` – Helm values and manifests for cluster add-ons.
- `docusaurus/` – source for the public documentation site.
- `scripts/` – helper utilities for exporting configs and environment variables.

Refer to the docs site for deeper walkthroughs of each area.

## Licensing

This project is licensed under the Apache 2.0 License. See the [LICENSE](LICENSE) file for details.