#!/bin/bash

echo "Setting up the Kubernetes configuration file...";
export KUBECONFIG=~/.kube/config-pulumi-hetzner-k3s; echo "Success";
