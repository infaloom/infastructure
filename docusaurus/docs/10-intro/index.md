---
slug: /
---

# Introduction

## Motivation

Running a Kubernetes cluster in production is not a trivial task. There are many aspects to consider, such as:
- Infrastructure provisioning
- Cluster installation
- Networking
- Storage
- Monitoring
- Logging
- Backups
- Security
- And more...

In my previous experience in managing Kubernetes clusters, I've found that there are many moving parts and it can be challenging to keep everything running smoothly. On top of that the price of managed services with major cloud providers can be quite high. 100s to 1000s of euros per month.

Given our internal expertise and the need to keep costs low, I decided to build a production ready infrastructure for our internal use at https://infaloom.com. Launched it in March 2025 and documented everything along the way. Decided to share it in case someone else finds it useful.

The goals of the infrastructure are to be:
- **Cost effective** for bootstrapped startups/small companies
- **Secure** by adhering to the best practices as much as possible
- **Highly available** and redundant
- **Independent from cloud providers and paid managed services** (easy to write new Pulumi code for other clouds if needed)
- **Easy to improve** and build upon for growing teams/companies

I'm looking forward to **feedback and suggestions** for improvements. Ideally we have a few of these in the wild so we can all learn and improve the setup over time. If you are curious about what is planned next, check the [roadmap](../roadmap.md).

:::note
I'm aware of some other similar projects. You should definitely check it out to see if it suits your needs better.

Though, I'm a kind of person who learns best by doing. In case something goes south, I'm much more comfortable fixing what is broken when I have a good understanding of the whole stack.
:::

## Target audience

:::info
This stack is going to cost you __EUR 187.34 per month__ as of November 2025. This is subject to change. Make sure you understand the costs before running it.
:::

This guide is for small companies/startups with internal DevOps expertise wanting to run a production ready [K3s](https://k3s.io) cluster on [Hetzner](https://hetzner.com) cloud.

It is a collection of commands, scripts, and explanations that should help with understanding the cluster deployment and management process.

It requires intermediate understanding of Linux and tools:
- [GNU Bash](https://www.gnu.org/software/bash/)
- [Pulumi](https://pulumi.com)
- [Ansible](https://github.com/ansible/ansible)
- [Kubernetes](https://kubernetes.io/)
- [Helm](https://helm.sh/)
- and others.

You can follow the guide without deep knowledge of these tools, but in certain cases it will be easier if you have some experience. For example if you want to modify the setup to suit your needs. Also in case a problem arises, you'd want to know what you are doing.

## Cluster resources

- 1 Load balancer
- 6 nodes total
  - 1 server for kube api load balancing (CPX11, HAProxy, cheaper than using the cloud load balancer for this purpose)
  - 3 servers
  - 3 agents
  - The nodes have 240gb of storage each.
- 6 external volumes on agents
  - 6 x 100GB
  - Note that this is part of a rook-ceph cluster with 3 replicas by default. So the effective distributed storage is 600GB / 3 = __200GB__. The rest is for redundancy.
- Total vCPU: __48__
- Total memory: __96GB__