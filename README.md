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
install-backupninja.mk # for roles requirements
install-backupninja.yml -l node
```

# Install duplicity

```
install-duplicity.yml -l node
```

# Generate and install ssh keys

```
ssh-keygen.yml -l node
```
