#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

stone := inventory/.stone
stone.deps := inventories.jsonnet nodes-lxc.jsonnet ext/data-nodes/oxa-duplicity.jsonnet
$(stone): $(stone.deps); mkdir -p $(@D); jsonnet -m $(@D) -S $< && touch $@

main: inventory/.stone

.PHONY: top main
