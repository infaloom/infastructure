#!/bin/bash
export SSH_SOURCE_IP="$(pulumi --cwd $PULUMI_CWD config get ssh:sourceIp)"; echo "SSH_SOURCE_IP exported";
export K3S_TOKEN="$(pulumi --cwd $PULUMI_CWD config get k3s:token)"; echo "K3S_TOKEN exported";
export LETSENCRYPT_EMAIL="$(pulumi --cwd $PULUMI_CWD config get letsencrypt:email)"; echo "LETSENCRYPT_EMAIL exported";
export CLUSTER_DOMAIN="$(pulumi --cwd $PULUMI_CWD config get cluster:domain)"; echo "CLUSTER_DOMAIN exported";