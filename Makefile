# Basic stuff
ifeq ($(V),1)
Q=
else
Q=@
endif

E=@echo

# OPA binaries
OPAPREFIX=/opt/mlstate/bin
OPAC=$(Q)$(OPAPREFIX)/opa
OPAPB=$(Q)$(OPAPREFIX)/opa-plugin-builder
OPACLOUD=$(Q)$(OPAPREFIX)/opa-cloud

OCAMLC=$(Q)ocamlc

CLOUD_OPTS?=--host localhost,2

all: build
build: plugins opaque
run: build
	./opaque.exe
cloud: build
	$(OPACLOUD) $(CLOUD_OPTS) ./opaque.exe

# Building
opaque:
	$(OPAC) opaque.opack -o opaque.exe
plugins:
# should handle building all this native crap better...
	$(OCAMLC) bsl/c/native.c
	$(Q)mv native.o bsl/c
	$(OPAPB) bsl/c/native.ml -o native.opp
# javascript bindings
	$(OPAPB) bsl/js/mathjax.js -o mathjax.opp

# Cleaning
clean:
	rm -rf *.opp bsl/c/*.o *.opx
	rm -rf *.exe _build _tracks *.log
	rm -rf *~ bsl/c/*~ bsl/js/*~ src/*~ res/*~
clean-db:
	rm -rf ~/.mlstate/opa-db-server
	rm -rf ~/.mlstate/opaque.exe
