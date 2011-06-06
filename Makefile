# Basic stuff
ifeq ($(V),1)
Q=
else
Q=@
endif

E=@echo
MV=mv

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
	$(E) Running normally...
	./opaque.exe
cloud: build
	$(E) Running in cloud mode...
	$(OPACLOUD) $(CLOUD_OPTS) ./opaque.exe

# Building
opaque:
	$(E) Building final exe...
	$(OPAC) opaque.opack -o opaque.exe
plugins:
# should handle building all this native crap better...
# native libs (rusage/uname stuff)
	$(E) Building native library/bindings...
	$(OCAMLC) bsl/c/native.c && $(MV) native.o bsl/c
	$(OPAPB) bsl/c/native.ml -o native.opp
# upskirt
	$(E) Building upskirt library/bindings...
	$(OCAMLC) bsl/c/upskirt/array.c && $(MV) array.o bsl/c/upskirt
	$(OCAMLC) bsl/c/upskirt/buffer.c && $(MV) buffer.o bsl/c/upskirt
	$(OCAMLC) bsl/c/upskirt/markdown.c && $(MV) markdown.o bsl/c/upskirt
	$(OCAMLC) bsl/c/upskirt/html.c && $(MV) html.o bsl/c/upskirt
	$(OCAMLC) bsl/c/upskirt/html_smartypants.c && $(MV) html_smartypants.o bsl/c/upskirt
	$(OCAMLC) bsl/c/upskirt/glue.c && $(MV) glue.o bsl/c/upskirt
	$(OPAPB) bsl/c/upskirt/upskirt.ml -o upskirt.opp

# javascript bindings
	$(E) Building mathjax bindings...
	$(OPAPB) bsl/js/mathjax.js -o mathjax.opp

# Cleaning
clean:
	rm -rf *.opp bsl/c/*.o bsl/c/upskirt/*.o *.opx
	rm -rf *.exe _build _tracks *.log
	rm -rf *~ bsl/c/*~ bsl/c/upskirt/*~ bsl/js/*~ src/*~ res/*~
clean-db:
	rm -rf ~/.mlstate/opa-db-server
	rm -rf ~/.mlstate/opaque.exe
