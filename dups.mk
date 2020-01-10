#!/usr/bin/make -f

MAKEFLAGS += -Rr
SHELL != which bash
SHELL += -o pipefail

self := $(lastword $(MAKEFILE_LIST))
$(self):;

top:; @date
.PHONY: top dirs main stone

dir := tmp
nodes := ext/data-nodes/oxa-duplicity.jsonnet
jsonnet := std.join(' ', std.map(function(s) '$(dir)' + '/' + s, (import '$(nodes)').dups.nodes))
dirs != jsonnet -Se "$(jsonnet)"
$(dirs): $(self) $(nodes); mkdir -p $@ && touch $@
dirs: $(dirs)

repo != git config remote.origin.url

stone := $(dir)/.stone
$(stone): dups.jsonnet dups.libsonnet $(nodes) $(self); jsonnet -V repo=$(repo) -m $(@D) -S $< && touch $@

main: dirs $(stone)
stone:; rm $(stone)
