# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/sys-fs/captive/captive-1.1.5.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $

DESCRIPTION="Captive uses binary Windows drivers for full NTFS r/w access."
HOMEPAGE="http://www.jankratochvil.net/project/captive/"
SRC_URI="http://www.jankratochvil.net/project/captive/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

# Todo: in the future add useflag for gui configuration
IUSE=""

DEPEND=">=sys-fs/ntfsprogs-1.8.0
	>=sys-fs/lufs-0.9.7
	>=gnome-extra/gnome-vfs-httpcaptive-2.3.8-r2"

src_compile() {
	econf --with-tmpdir=/tmp --localstatedir=/var || die
	emake || die
}

src_install() {
	einfo Adding captive user and group
	enewgroup captive
	enewuser captive -1 /bin/false /dev/null captive

	emake install DESTDIR=${D} || die

        dodoc AUTHORS COPYING* ChangeLog* \
                NEWS README* TODO || \
                        die "dodoc failed"
}

pkg_postinst() {
	einfo "Use /usr/sbin/captive-install-acquire to search for and"
	einfo "install the needed drivers for captive NTFS."
	einfo ""
	einfo "Use /usr/sbin/captive-install-fstab to install captive"
	einfo "entries into your /etc/fstab."
}

pkg_postrm() {
	#einfo Removing captive user
	#userdel captive
	#einfo Removing captive group
	#groupdel captive

	einfo ""
	einfo "You will have to remove captive user and group manually"
	einfo ""
}
