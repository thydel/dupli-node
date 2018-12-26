#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

main:; ansible-galaxy install -r backup-requirements.yml

.PHONY: top main
