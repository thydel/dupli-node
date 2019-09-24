top:; @date

inventory.mk:;

ext/ips/data-ips: ext/data-ips; ln -s ../$(<F) $@
ext/data-ips:;

ext/ips/out: ext/ips/data-ips; make -C $(@D)

ext/inventories/ips: ext/ips/out; ln -s $(subst ext,..,$<) $@

ext/inventories/inventory/local.INI: ext/inventories/ips; make -C ext/inventories -f nodes.mk full
ext/inventories/inventory/oxa-groups.INI: ext/inventories/ips; make -C ext/inventories -f groups.mk full

main: ext/inventories/inventory/local.INI ext/inventories/inventory/oxa-groups.INI inventory
.PHONY: main

remake/main remake/full:
	make --no-print-directory -C ext/ips
	make --no-print-directory -C ext/inventories -f nodes.mk $(@F)
	make --no-print-directory -C ext/inventories -f groups.mk $(@F)
remake: remake/main
.PHONY: remake remake/main remake/full

inventory: ext/inventories/inventory; ln -s $< $@
