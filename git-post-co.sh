#!/bin/sh

emptyfolders="debian/etc/NetworkManager/dispatcher.d debian/etc/proxydriver.d \
debian/usr/share/doc/proxydriver debian/var/lib/proxydriver"
files="Makefile proxydriver.sh changelog.debian copyright debian/DEBIAN/control \
debian/DEBIAN/postinst debian/DEBIAN/postrm"
exec="proxydriver.sh debian/DEBIAN/control debian/DEBIAN/postinst debian/DEBIAN/postrm"

for i in $emptyfolders
do
	echo Create empty folder $i
	mkdir -p $i
done

for i in $files
do
	echo Adjusting mode of file $i
	chmod 644 $i
done

for i in $exec
do
	echo Making executable file $i
	chmod +x $i
done
