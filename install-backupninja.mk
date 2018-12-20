#!/usr/bin/make -f

MAKEFLAGS += -Rr

top:; @date

main:; ansible-galaxy install -r install-backupninja-requirements.yml

.PHONY: top main
