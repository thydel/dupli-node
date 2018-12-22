#!/usr/bin/make -f

MAKEFLAGS += -Rr
SHELL != which bash
SHELL += -o pipefail

self := $(lastword $(MAKEFILE_LIST))
$(self):;

top:; @date
.PHONY: top dirs main

dir := tmp
jsonnet := local nodes = import 'ext/data-nodes/oxa-duplicity.jsonnet';
jsonnet += 'mkdir -p $(dir); proot -w $(dir) mkdir -p ' + std.join(' ', nodes.dups.nodes)
dirs := $(dir)/.dirs
$(dirs) = jsonnet -Se "$(jsonnet)" | tee /dev/stderr | dash && touch $@
$(dirs): $(self); $($@)
dirs: $(dirs)

stone := $(dir)/.stone
$(stone): dups.jsonnet dups.libsonnet $(self); jsonnet -m $(@D) -S $< && touch $@

main: dirs $(stone)
