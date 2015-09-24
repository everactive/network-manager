all:

INSTALLED_DEPS := parts/ubuntu-deps/install

install:
	# workaround hardcoded pathnames to NMPLUGINDIR and NMSTATEDIR by
	# replacing /usr/... with !usr/... and creating a !usr -> usr symlink
	mkdir -p $(DESTDIR)
	rm -f $(DESTDIR)/!usr
	rm -f $(DESTDIR)/!var
	ln -sf usr $(DESTDIR)/!usr
	ln -sf var $(DESTDIR)/!var
	mkdir $(DESTDIR)/usr
	mkdir $(DESTDIR)/var
	mkdir -p $(DESTDIR)/bin
	sed \
	    -e 's#/usr/lib/#!usr/lib/#g' \
	    -e 's#/var/lib/NetworkManager#!var/lib/NetworkManager#g' \
	    $(INSTALLED_DEPS)/usr/sbin/NetworkManager \
	    >$(DESTDIR)/bin/NetworkManager.patched.tmp
	chmod +x $(DESTDIR)/bin/NetworkManager.patched.tmp
	mv $(DESTDIR)/bin/NetworkManager.patched.tmp \
	    $(DESTDIR)/bin/NetworkManager.patched

