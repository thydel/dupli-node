# Generate ansible config

```
ansible-cfg.mk main
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
