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

all: native.opp opaque.exe
run: opaque.exe
	./opaque.exe
cloud:
	$(OPACLOUD) $(CLOUD_OPTS) ./opaque.exe

# Building
opaque.exe:
	$(OPAC) opaque.opack -o opaque.exe
native.opp: bsl/native.c
	$(OCAMLC) bsl/native.c
	$(Q)mv native.o bsl
	$(OPAPB) bsl/native.ml -o native.opp

clean:
	rm -rf *.opp bsl/*.o *.opx
	rm -rf *.exe _build _tracks *.log
	rm -rf *~ bsl/*~ src/*~ res/*~
