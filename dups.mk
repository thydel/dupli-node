#!/usr/bin/make -f

MAKEFLAGS += -Rr
SHELL != which bash
SHELL += -o pipefail

self := $(lastword $(MAKEFILE_LIST))
$(self):;

top:; @date
.PHONY: top dirs main

dir := tmp
nodes := ext/data-nodes/oxa-duplicity.jsonnet
jsonnet := local nodes = import '$(nodes)';
jsonnet += 'mkdir -p $(dir); proot -w $(dir) mkdir -p ' + std.join(' ', nodes.dups.nodes)
dirs := $(dir)/.dirs
$(dirs) = jsonnet -Se "$(jsonnet)" | tee /dev/stderr | dash && touch $@
$(dirs): $(self) $(nodes); $($@)
dirs: $(dirs)

repo != git config remote.origin.url

stone := $(dir)/.stone
$(stone): dups.jsonnet dups.libsonnet $(nodes) $(self); jsonnet -V repo=$(repo) -m $(@D) -S $< && touch $@

main: dirs $(stone)
