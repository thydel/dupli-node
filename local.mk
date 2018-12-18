#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

local := inventory/local.yml
$(local): local.jsonnet; jsonnet -m $(@D) -S $< && touch -r $< $@

main: $(local)
.PHONY: main
