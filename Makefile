all:

INSTALLED_DEPS := parts/ubuntu-deps/install

install:
	pwd
	ls $(INSTALLED_DEPS)/usr/sbin
	# workaround hardcoded pathnames to NMPLUGINDIR and NMSTATEDIR by
	# replacing /usr/... with !usr/... and creating a !usr -> usr symlink
	rm -f $(DESTDIR)/!usr
	rm -f $(DESTDIR)/!var
	ln -sf usr $(DESTDIR)/!usr
	ln -sf var $(DESTDIR)/!var
	mkdir $(DESTDIR)/usr
	mkdir $(DESTDIR)/var
	mkdir -p $(DESTDIR)/usr/sbin
	sed \
	    -e 's#/usr/lib/#!usr/lib/#g' \
	    -e 's#/var/lib/NetworkManager#!var/lib/NetworkManager#g' \
	    $(INSTALLED_DEPS)/usr/sbin/NetworkManager \
	    >$(DESTDIR)/usr/sbin/NetworkManager.patched.tmp
	chmod +x $(DESTDIR)/usr/sbin/NetworkManager.patched.tmp
	mv $(DESTDIR)/usr/sbin/NetworkManager.patched.tmp \
	    $(DESTDIR)/usr/sbin/NetworkManager.patched

