# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/sys-fs/lufis/lufis-0.2.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $

DESCRIPTION="LUFS->FUSE wrapper"
SRC_URI="mirror://sourceforge/avf/${P}.tar.gz"
HOMEPAGE="http://avf.sourceforge.net/"
LICENSE="GPL-2"
RDEPEND=">=sys-fs/lufs-0.9.7
	>=sys-fs/fuse-1.1"
DEPEND="${RDEPEND}"
KEYWORDS="~x86"
SLOT="0"

src_compile () {
	emake
}

src_install () {
	dobin lufis
	dodoc README COPYING ChangeLog
}

pkg_postinst() {
	einfo Please use lufis to mount partition, e.g.:
	einfo lufis "fs=captivefs,dir_cache_entries=0,image=/dev/hda1,captive_options=--rw;--load-module=/var/lib/captive/ntoskrnl.exe;--filesystem=/var/lib/captive/ntfs.sys;--sandbox-server=/usr/sbin/captive-sandbox-server;" /mnt/ntfs -s
}
