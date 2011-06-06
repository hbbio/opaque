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
build: native opaque
run: build
	./opaque.exe
cloud: build
	$(OPACLOUD) $(CLOUD_OPTS) ./opaque.exe

# Building
opaque:
	$(OPAC) opaque.opack -o opaque.exe
native: bsl/native.c
# should handle building all this native crap better...
	$(OCAMLC) bsl/native.c
	$(Q)mv native.o bsl
	$(OPAPB) bsl/native.ml -o native.opp

# Cleaning
clean:
	rm -rf *.opp bsl/*.o *.opx
	rm -rf *.exe _build _tracks *.log
	rm -rf *~ bsl/*~ src/*~ res/*~
clean-db:
	rm -rf ~/.mlstate/opa-db-server
	rm -rf ~/.mlstate/opaque.exe
