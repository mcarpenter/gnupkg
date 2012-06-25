
# Executables
COL=/usr/bin/col
EQNCHAR=/usr/share/lib/pub/eqnchar
INSTALL=/usr/sbin/install
NEQN=/usr/bin/neqn
NROFF=/usr/bin/nroff
RM=/usr/bin/rm
RMDIR=/usr/bin/rmdir
TBL=/usr/bin/tbl

# Packaging
BIN=gnupkg
BINDIR=$(DESTDIR)/usr/local/bin
MANDIR=$(DESTDIR)/usr/local/man/man1
ARCH=all
EMAIL=mcarpenter@free.fr
PREFIX=MJC
VENDOR=http://github.com/mcarpenter/$(BIN)
VERSION=$(shell ./$(BIN) -v)


.PHONY: all
all: pkgstream

README: $(BIN).cat
	$(COL) -b -x < $(BIN).cat > README

$(BIN).cat: $(BIN).1
	$(TBL) $(BIN).1 | $(NEQN) $(EQNCHAR) - | $(NROFF) -u0 -Tlp -man - > $(BIN).cat

.PHONY: clean
clean:
	$(RM) -f $(BIN).cat README
	$(RM) -rf $(PREFIX)$(BIN)*

.PHONY: pkg
pkg:
	./$(BIN) -c: -b: -p arch=$(ARCH),email=$(EMAIL),prefix=$(PREFIX),vendor=$(VENDOR),version=$(VERSION) $(PWD)

.PHONY: pkgstream
pkgstream:
	./$(BIN) -s -c: -b: -p arch=$(ARCH),email=$(EMAIL),prefix=$(PREFIX),vendor=$(VENDOR),version=$(VERSION) $(PWD)

.PHONY: install
install:
	[ -d $(BINDIR) ] || $(INSTALL) -d $(BINDIR) -m755 -uroot -groot
	[ -d $(MANDIR) ] || $(INSTALL) -d $(MANDIR) -m644 -uroot -groot
	$(INSTALL) -f $(BINDIR) $(BIN)
	$(INSTALL) -f $(MANDIR) $(BIN).1

.PHONY: uninstall
uninstall:
	$(RM) -f $(BINDIR)/$(BIN) $(MANDIR)/$(BIN).1
	$(RMDIR) $(BINDIR) $(MANDIR)

