VERSION=1.62
ARCH=all
CP=cp
MV=mv
GZIP=gzip

.PHONY: deb
deb: proxydriver_$(VERSION)_$(ARCH).deb

.PHONY: proxydriver_$(VERSION)_$(ARCH).deb
proxydriver_$(VERSION)_$(ARCH).deb: proxydriver.sh changelog.debian copyright debian
	mkdir -p debian/usr/lib/proxydriver debian/usr/share/doc/proxydriver && \
	$(CP) proxydriver.sh debian/usr/lib/proxydriver/proxydriver.sh && \
	$(GZIP) -n -9 -c changelog.debian > debian/usr/share/doc/proxydriver/changelog.gz && \
	$(CP) copyright debian/usr/share/doc/proxydriver/ && \
	chmod 0775 debian/DEBIAN/post* && \
	echo '/etc/NetworkManager/dispatcher.d/99proxydriver.sh' >> debian/DEBIAN/conffiles && \
	fakeroot dpkg --build debian &&  \
	$(MV) debian.deb $@ && \
	which lintian > /dev/null && lintian $@ && \
	rm debian/DEBIAN/conffiles

.PHONY: clean
clean: 
	$(RM) debian/usr/share/doc/proxydriver/copyright && \
	$(RM) debian/usr/share/doc/proxydriver/changelog.gz && \
	$(RM) debian/etc/NetworkManager/dispatcher.d/99proxydriver.sh && \
	$(RM) proxydriver_$(VERSION)_$(ARCH).deb

.PHONY: install
install: proxydriver_$(VERSION)_$(ARCH).deb
	dpkg --install $^

.PHONY: remove
remove:
	dpkg --remove proxydriver

.PHONY: tarball
tarball: proxydriver-$(VERSION).tgz

.PHONY: proxydriver-$(VERSION).tgz
proxydriver-$(VERSION).tgz: proxydriver.sh changelog.debian copyright Makefile debian
	tar cvzf $@ $^
