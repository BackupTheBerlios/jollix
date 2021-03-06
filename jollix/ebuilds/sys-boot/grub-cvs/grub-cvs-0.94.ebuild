# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/xubuntu/berlios_backup/github/tmp-cvs/jollix/Repository/jollix/ebuilds/sys-boot/grub-cvs/grub-cvs-0.94.ebuild,v 1.1 2004/05/23 12:07:04 genstef Exp $

inherit cvs mount-boot eutils flag-o-matic gcc

SRC_URI="ftp://ftp.gwdg.de/pub/linux/suse/ftp.suse.com/suse/i386/9.1/suse/src/grub-0.94-25.src.rpm"
RESTRICT="nomirror"

ECVS_AUTH="ext"
ECVS_USER="anoncvs"
ECVS_PASS=""
ECVS_CVS_OPTIONS="-dP"
ECVS_SERVER="savannah.gnu.org:/cvsroot/grub"
ECVS_MODULE="grub"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"

S=${WORKDIR}/${ECVS_MODULE}
DESCRIPTION="GRUB boot loader from  cvs for iso-boot and SuSE-gfxboot patches"
HOMEPAGE="http://www.gnu.org/software/grub/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="static"

DEPEND=">=sys-libs/ncurses-5.2-r5
	>=sys-devel/autoconf-2.5
	>=dev-util/cvs-1.11.15
	!sys-boot/grub"
PROVIDE="virtual/bootloader"

src_unpack() {
	cvs_src_unpack
	cd ${WORKDIR}
	rpm2targz ${DISTDIR}/grub-0.94-25.src.rpm
	tar xzf grub-0.94-25.src.tar.gz
	cd ${S}
	# This patchset is from SuSE
	patch -p1 < ${WORKDIR}/force-LBA-off.diff
	patch -p1 < ${WORKDIR}/grub-0.94-devicemap.diff
	patch -p1 < ${WORKDIR}/grub-0.94-initrdaddr.diff
	patch -p1 < ${WORKDIR}/grub-0.94-path-patch
	patch -p1 < ${WORKDIR}/grub-R
	patch -p1 < ${WORKDIR}/grub-splashscreen-v4
	patch -p0 < ${WORKDIR}/grub-splashscreen-v4_v5
	patch -p0 < ${WORKDIR}/use_ferror.diff

	# This patchset is from SuSE -- hopefully fixes the acl symlink issue
	# And should add some boot prettification
#	epatch ${WORKDIR}/${PF}-gentoo.diff
#	epatch ${FILESDIR}/${P}-test.patch
}

src_compile() {
	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.
	unset CFLAGS

	filter-ldflags -pie
	append-flags -DNDEBUG
	[ `gcc-major-version` -eq 3 ] && append-flags -minline-all-stringops
	use static && append-ldflags -static

	# http://www.gentoo.org/proj/en/hardened/etdyn-ssp.xml
	has_pie && CC="${CC} `test_flag -yet_exec``test_flag -nopie`"
	has_ssp && CC="${CC} `test_flag -yno_propolice``test_flag -fno-stack-protector`"

	autoconf || die
	aclocal || die
	automake || die

	# build the net-bootable grub first
	CFLAGS="" \
	econf \
		--datadir=/usr/lib/grub \
		--exec-prefix=/ \
		--disable-auto-linux-mem-opt \
		--enable-diskless \
		--enable-{3c{5{03,07,09,29,95},90x},cs89x0,davicom,depca,eepro{,100}} \
		--enable-{epic100,exos205,ni5210,lance,ne2100,ni{50,65}10,natsemi} \
		--enable-{ne,ns8390,wd,otulip,rtl8139,sis900,sk-g16,smc9000,tiara} \
		--enable-{tulip,via-rhine,w89c840} || die

	emake w89c840_o_CFLAGS="-O" || die "making netboot stuff"

	mv stage2/{nbgrub,pxegrub} ${S}
	mv stage2/stage2 stage2/stage2.netboot

	make clean || die

	# now build the regular grub
	CFLAGS="${CFLAGS}" \
	econf \
			--datadir=/usr/lib/grub \
			--exec-prefix=/ \
			--disable-auto-linux-mem-opt || die
	emake || die "making regular stuff"
}

src_install() {
	make DESTDIR=${D} install || die
	exeinto /usr/lib/grub
	doexe nbgrub pxegrub stage2/stage2 stage2/stage2.netboot

	insinto /boot/grub
	newins docs/menu.lst grub.conf.sample

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
}

pkg_postinst() {
	[ "$ROOT" != "/" ] && return 0

	# change menu.lst to grub.conf
	if [ ! -e /boot/grub/grub.conf -a -e /boot/grub/menu.lst ]
	then
		mv /boot/grub/menu.lst /boot/grub/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi
	einfo "Linking from new grub.conf name to menu.lst"
	ln -s grub.conf /boot/grub/menu.lst

	[ -e /boot/grub/stage2 ] && mv /boot/grub/stage2{,.old}

	einfo "Copying files from /usr/lib/grub to /boot"
	cp -p /usr/lib/grub/* /boot/grub
	cp -p /usr/lib/grub/grub/*/* /boot/grub

	[ -e /boot/grub/grub.conf ] \
		&& /usr/sbin/grub \
			--batch \
			--device-map=/boot/grub/device.map \
			< /boot/grub/grub.conf > /dev/null 2>&1
}
