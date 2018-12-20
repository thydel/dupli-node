#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

stone := ansible-cfg/.stone
$(stone): ansible-cfg.jsonnet; mkdir -p $(@D); jsonnet -m $(@D) -S $< && touch $@

confs := mini full simple
$(confs): $(stone); ln -sf ansible-cfg/$@.cfg ansible.cfg
main: full
.PHONY: $(confs) main
