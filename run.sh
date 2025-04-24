#!/bin/bash

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Error: ansible-playbook command not found. Please install Ansible first."
    echo "You can install it using: pip install ansible"
    exit 1
fi

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <ssh_key_path> <ip_address> [ssh_user] [bioc_version]"
    echo ""
    echo "Parameters:"
    echo "  ssh_key_path  : Path to SSH private key for connection"
    echo "  ip_address    : IP address of the target server"
    echo "  ssh_user      : SSH username (default: ubuntu)"
    echo "  bioc_version  : Bioconductor version to sync (e.g. 3.21)"
    exit 1
fi

SSH_KEY_PATH=$1
IP_ADDRESS=$2
SSH_USER=${3:-ubuntu}
BIOC_VERSION=${4:-"3.21"}

echo "Starting Bioconductor sync for version $BIOC_VERSION..."
ansible-playbook -v playbook.yml -e "ssh_key_path=$SSH_KEY_PATH ip_address=$IP_ADDRESS ssh_user=$SSH_USER bioc_version=$BIOC_VERSION"
