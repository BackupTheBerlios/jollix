# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/sys-boot/gfxboot/gfxboot-2.4.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $
DESCRIPTION="Graphical Bootup message creation tool"
HOMEPAGE="http://www.suse.com/"
SUBVERSION="41"
SRC_URI="ftp://ftp.gwdg.de/pub/linux/suse/ftp.suse.com/suse/i386/9.1/suse/src/${P}-${SUBVERSION}.src.rpm"
RESTRICT="nomirror"
LICENSE="GPL"
SLOT="0"
IUSE=""
DEPEND=">=app-arch/rpm2targz-9.0-r2"
KEYWORDS="-* ~x86"
S=${WORKDIR}/${P}

src_unpack() {
rpm2targz ${DISTDIR}/${P}-${SUBVERSION}.src.rpm
tar xzf ${P}-${SUBVERSION}.src.tar.gz
tar xjf ${P}.tar.bz2
tar xjf SuSE.tar.bz2 -C gfxboot-2.4
tar xjf SuSE-Home.tar.bz2 -C gfxboot-2.4
sed -s -i "s|/usr/X11/lib|/usr/X11R6/lib|" ${P}/Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin mkbootmsg getx11font help2txt
	dodoc README COPYING Changelog
	dodir /usr/share/gfxboot
	cp -a themes ${D}/usr/share/gfxboot
}
