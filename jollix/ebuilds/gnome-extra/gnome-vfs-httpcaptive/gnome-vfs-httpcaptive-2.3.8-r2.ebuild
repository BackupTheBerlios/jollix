# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/gnome-extra/gnome-vfs-httpcaptive/gnome-vfs-httpcaptive-2.3.8-r2.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $

inherit gnome2

S=${WORKDIR}/${P}captive2

IUSE=""
DESCRIPTION="GNOME Virtual File System module for captive NTFS"
HOMEPAGE="http://www.jankratochvil.net/project/captive"
SRC_URI="http://www.jankratochvil.net/project/captive/dist/${P}captive2.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND=">=gnome-base/gnome-vfs-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"
