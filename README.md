# Bioconductor Archive Sync

This Ansible playbook automates the process of syncing a Bioconductor release to the Open Storage Network (OSN) archive. It handles the full workflow of:

1. Retrieving the specified Bioconductor version from the master Bioconductor server
2. Creating the necessary directory structure locally
3. Transferring the retrieved data to OSN for archival storage

## Prerequisites

### On Your Local Machine (Running Ansible)

- Ansible installed (`pip install ansible`)
- SSH access to the target server
- SSH key for connecting to the target server
- Knowledge of the target server's IP address and SSH user credentials

### On The Target Machine (Running the Sync)

- SSH key `~/.ssh/rsync.pem` for connecting to the Bioconductor master server
- Rclone configuration file at `~/.rclone.conf` with an [osn] remote defined

Note: The playbook will automatically check for these prerequisites on the target machine. If rclone is not installed on the target machine, the playbook will automatically install it.

## How to Use

The simplest way to run this playbook is by using the provided `run.sh` script.

### Using run.sh

The run.sh script simplifies execution by handling all the necessary parameters:

```bash
./run.sh <ssh_key_path> <ip_address> [ssh_user] [bioc_version]
```

#### Parameters:

- **ssh_key_path**: Path to your SSH private key for connecting to the target server
- **ip_address**: IP address of the target server where the sync will run
- **ssh_user**: (Optional) SSH username for connecting to the target server (default: ubuntu)
- **bioc_version**: (Optional) The Bioconductor version to sync (default: 3.21)

#### Example usage:

```bash
./run.sh ~/.ssh/my_key.pem 192.168.1.100 ubuntu 3.20
```

### Best Practice: Run Multiple Times

It's recommended to run the script at least twice:
- The first run will transfer all the data, which may take significant time depending on the size of the Bioconductor release
- Subsequent runs will be much faster and ensures that all transfers were successful
- If the second run shows no additional files being transferred or updated, it confirms that the synchronization is complete and consistent

This approach leverages rsync and rclone's internal check mechanisms - it only transfers files that have changed or are missing, making subsequent runs both a verification and a way to complete any interrupted transfers.

### Best Practice: Use Screen for Persistent Sessions

I'd recommended you use `screen`, especially on a VM, to ensure the process continues even if your connection to the VM is interrupted:

```bash
# Start a new screen session
screen -S bioc-sync

# Now run the script inside the screen session
./run.sh ~/.ssh/rsync.pem 192.168.1.100 ubuntu 3.21

# You can detach from the screen session with: Ctrl+A, then D
```

After starting a screen session, you can leave it unattended for a couple of hours, while the transfers happen.

When returning to the session:

```bash
# If disconnected, you can reconnect to the VM and resume the session with:
screen -r bioc-sync
```

This approach protects your sync process from:
- Network connectivity issues between your computer and the VM
- Local computer shutdowns or sleep mode
- SSH session timeouts
- Accidental terminal closing

The transfer will continue running on the VM even if your connection drops, and you can easily reconnect to check progress when needed.
