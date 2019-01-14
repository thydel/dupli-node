# Generate ansible config

```
ansible-cfg.mk main
ansible-cfg.yml
```

# Generate minimal inventory

```
local.mk main
```

# Define private variables

- define `data_nodes_repo` in `private-repos.yml`
- define `default_key` in `keys.yml`

# Get private stuff

```
init.yml
```

# Generate private inventory

Uses `data_nodes_repo`

```
inventories.mk main
```

# Install backupninja

```
install-backupninja.mk main # for roles requirements
install-backupninja.yml -l node
```

# Install duplicity

```
install-duplicity.yml -l node
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
