# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/net-print/foo2zjs/foo2zjs-20040516.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $
DESCRIPTION="Support for printing to ZjStream-based printers"
HOMEPAGE="http://foo2zjs.rkkda.com/"
SRC_URI="http://foo2zjs.rkkda.com/${PN}.tar.gz
	ftp://ftp.minolta-qms.com/pub/crc/out_going/win/m23dlicc.exe
	ftp://ftp.minolta-qms.com/pub/crc/out_going/win2000/m22dlicc.exe
	ftp://ftp.minolta-qms.com/pub/crc/out_going/windows/cpplxp.exe
	ftp://192.151.53.86/pub/softlib/software2/COL2222/lj-10067-2/lj1005hostbased-en.exe
	ftp://ftp.hp.com/pub/softlib/software1/lj1488/lj-1145-2/lj1488en.exe"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
IUSE="cups foomaticdb"
DEPEND="cups? ( >=net-print/cups-1.1.20-r1 )
	foomaticdb? ( >=net-print/foomatic-3.0.1 )"
KEYWORDS="-* ~x86"
S=${WORKDIR}/${PN}

src_unpack() {
	tar xzf ${DISTDIR}/${PN}.tar.gz
	for i in `echo ${A} | sed "s/^.[a-z0-9.]* //"`
	do
	cp ${DISTDIR}/${i} ${S}
	done
}

src_compile() {
	emake || die "emake failed"
}

src_install() {

# unpack the firmware
	sed -si "s/.*wget.*//" getweb
	./getweb 2300	# Get Minolta 2300 DL .ICM files
	./getweb 2200	# Get Minolta 2200 DL .ICM files
	./getweb cpwl	# Get Minolta Color PageWorks/Pro L .ICM files
	./getweb 1005	# Get HP LJ1005 firmware file
	./getweb 1000     # Get HP LJ1000 firmware file
# install
	sed -si "s|PREFIX=\/usr|PREFIX=${D}/usr|" Makefile
	dodir /usr/bin
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		all install-prog install-icc2ps install-extra install-man install-doc || die	
# install-hotplug
	USBDIR="/etc/hotplug/usb"
	dodir ${USBDIR}/
	install -c -m 755 hplj1000 ${D}/${USBDIR}/
	ln -sf ${D}/${USBDIR}/hplj1000 ${D}/${USBDIR}/hplj1005
	
	cat >${D}/etc/hotplug/usb.usermap<<EOF
# usb module         match_flags idVendor idProduct bcdDevice_lo bcdDevice_hi bDeviceClass bDeviceSubClass bDeviceProtocol bInterfaceClass bInterfaceSubClass bInterfaceProtocol driver_info
hplj1000 0x0003 0x03f0 0x0517 0x0000 0x0000 0x00 0x00 0x00 0x00 0x00 0x00 0x00000000
hplj1005 0x0003 0x03f0 0x1317 0x0000 0x0000 0x00 0x00 0x00 0x00 0x00 0x00 0x00000000
EOF

# install-foo	
	if use foomaticdb; then
		FOODB=/usr/share/foomatic/db/source
		dodir ${FOODB} ${FOODB}/driver ${FOODB}/printer ${FOODB}/opt
		FOODB=${D}/usr/share/foomatic/db/source
		#@if [ -d $(FOODB) ]; then \ 
		for dir in driver printer opt; do \
			echo install -m 644 foomatic-db/$dir/*.xml ${FOODB}/$dir/; \
			install -c -m 644 foomatic-db/$dir/*.xml ${FOODB}/$dir/; \
		done \
	fi

# install-ppd
# Generate PPD files using local tools
	if use cups; then
		[ -d PPD ] || mkdir PPD
		for i in foomatic-db/printer/*.xml
		do
			printer=`basename $i .xml`
			echo $printer
			case "$printer" in
			*1500*|*OAKT*)      driver=foo2oak;;
			*)                  driver=foo2zjs;;
			esac
			foomatic-ppdfile -d $driver -p $printer > PPD/$printer.ppd
		done
	
		MODEL="/sur/share/cups/model"
		#
		# Install PPD files for CUPS
		#
		dodir  ${MODEL}
		cd PPD
		for ppd in *.ppd; do
			gzip < $ppd > ${D}/${MODEL}/$ppd.gz;
		done
	fi
}
