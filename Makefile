VERSION=1.60
ARCH=all
CP=cp
MV=mv
GZIP=gzip

.PHONY: deb
deb: proxydriver_$(VERSION)_$(ARCH).deb

.PHONY: proxydriver_$(VERSION)_$(ARCH).deb
proxydriver_$(VERSION)_$(ARCH).deb: proxydriver.sh changelog.debian copyright debian
	$(CP) proxydriver.sh debian/usr/share/doc/proxydriver/ && \
	$(GZIP) -n -9 -c changelog.debian > debian/usr/share/doc/proxydriver/changelog.gz && \
	$(CP) copyright debian/usr/share/doc/proxydriver/ && \
	fakeroot dpkg --build debian &&  \
	$(MV) debian.deb $@ && \
	lintian $@

.PHONY: clean
clean: 
	$(RM) debian/usr/share/doc/proxydriver/copyright && \
	$(RM) debian/usr/share/doc/proxydriver/changelog.gz && \
	$(RM) debian/usr/share/doc/proxydriver/proxydriver.sh && \
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
