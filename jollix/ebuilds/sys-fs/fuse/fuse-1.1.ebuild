# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/sys-fs/fuse/fuse-1.1.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $

DESCRIPTION="User-mode filesystem implementation"
SRC_URI="mirror://sourceforge/avf/${P}.tar.gz"
HOMEPAGE="http://avf.sourceforge.net/"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"
RDEPEND=""
KEYWORDS="~x86"
SLOT="0"
IUSE="fuseusermount"

src_unpack () {
	unpack ${A}
	epatch ${FILESDIR}/${P}-no-depmod.patch
}
	
src_install () {
	dodoc AUTHORS BUGS COPYING COPYING.LIB ChangeLog Filesystems INSTALL \
		NEWS README README-2.4 README-2.6 README.NFS TODO
	make DESTDIR=${D} install

	use fuseusermount || chmod -s ${D}/usr/bin/fusermount
}

pkg_postinst() {
	/usr/sbin/update-modules
	if ! use fuseusermount
	then
		einfo If you want regular users to be able to mount fuse filesystems,
		einfo you need to run the following command as root:
		einfo \# chmod +s /usr/bin/fusermount
		einfo You can also set the fuseusermount USE flag to do this
		einfo automatically.
	fi
}

pkg_postrm() {
	/sbin/modprobe -r fuse
}
