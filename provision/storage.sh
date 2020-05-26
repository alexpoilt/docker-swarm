#!/bin/bash

apt-get install -y nfs-kernel-server

mkdir -p /srv/nfs/v{0..9}

cat > /etc/exports <<EOF
/srv/nfs/v0 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v1 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v2 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v3 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v4 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v5 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v6 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v7 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v8 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
/srv/nfs/v9 172.27.11.0/24(rw,no_root_squash,no_subtree_check)
EOF

exportfs -a
