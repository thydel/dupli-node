# Fetch

```
git clone git@github.com:thydel/dupli-node.git
```

# Use a gmk file

```
gmk self/config
gmk mailmap
gmk conf
gmk exclude
gmk mailmaps
```

# Add and use a Makefile to generate inventory

```
make -f inventory.mk main
```

# Choose and configure ansible

```
make -C ext/ansible-cfg install
ansible-cfg median
source <(use-ansible)
ansible-cfg exclude
```

# Use ansible with inventory

```
source <(use-ansible)
ansible 'n_admin2:!g_poweredoff' -om ping
```

# Install backupninja

```
install-backupninja.mk main # for roles requirements
source <(use-ansible 2.8)
install-backupninja.yml -l $node
```

# Install duplicity

```
install-duplicity.yml -l $node
```

# Generate and install SSH keys

```
ssh-keygen.yml -l node # -e no_assert=1
```

# Generate and install GPG keys

```
gpg.yml -l node # -e no_assert=1
```

# Generate and intrall dups

Uses `data_nodes_repo`

```
dups.yml -l node # -e no_assert=1
```

# Reset known_hosts entry

```
remote-reset-known-hosts-entry.yml -l node -e no_assert=1
```
