# Copyright 2004-2006 SabayonLinux
# Distributed under the terms of the GNU General Public License v2
# Ebuild is now versioned by release, ex. 3.25, 3.3, 3.3_pre1, etc

inherit eutils versionator

DESCRIPTION="Sabayon Linux Official artwork, can include wallpapers, ksplash, and GTK/QT Themes."
HOMEPAGE="http://www.sabayonlinux.org/"
SRC_URI="http://www.sabayonlinux.org/distfiles/x11-themes/${PN}/${PN}-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc ppc64"
IUSE="symlink"
#RESTRICT="nomirror"
DEPEND=">=x11-libs/gtk+-2.8
	>=kde-misc/ksplash-engine-moodin-0.4.2
	"


RDEPEND=""

S="${WORKDIR}/${PN}"

src_install () {

	if [ ! -e ${ROOT}/usr/share/backgrounds ]; then
          dodir ${ROOT}/usr/share/backgrounds
        fi

	if [ ! -e ${ROOT}/usr/share/themes ]; then
          dodir ${ROOT}/usr/share/themes
        fi

	if [ ! -e ${ROOT}/etc/splash ]; then
          dodir ${ROOT}/etc/splash
        fi

	cd ${S}/background
	insinto ${ROOT}/usr/share/backgrounds
	doins *.jpg *.png

	cd ${S}/gtk
	insinto ${ROOT}/usr/share/themes
	doins -r ./

	if [ -e ${ROOT}/usr/kde/3.5 ]; then
	  kdedir="${ROOT}/usr/kde/3.5"
	elif [ -e ${ROOT}/usr/kde/3.4 ]; then
	  kdedir="${ROOT}/usr/kde/3.4"
	else
	  kdedir="nokde"	
	fi

	if [ "$kdedir" != "nokde" ] && [ -e "$kdedir/share/apps/ksplash/Themes" ]; then
	  cd ${S}/ksplash
	  insinto ${ROOT}/$kdedir/share/apps/ksplash/Themes
	  doins -r ./
	  # KDM theme
	  cd ${S}/kdm
	  insinto ${ROOT}/$kdedir/share/apps/kdm/themes/
	  doins -r ./
	fi

	# Gensplash theme
	cd ${S}/gensplash
        dodir /etc/splash/sabayon
        cp -r ${S}/gensplash/sabayon/* ${D}/etc/splash/sabayon

	# Emerald theme
	cd ${S}/emerald
	dodir ${ROOT}/usr/share/emerald/themes
	insinto ${ROOT}/usr/share/emerald/themes
	doins -r ./

	# Mouse cursor theme
	#X11_IMPLEM_P="$(best_version virtual/x11)"
	#X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
	#X11_IMPLEM="${X11_IMPLEM##*\/}"
	X11_IMPLEM="xorg-x11"
	einfo "X11 implementation is ${X11_IMPLEM}."

	# Make sure you change the mouse cursor theme name here each release its changed
	dodir /usr/share/cursors/${X11_IMPLEM}/
	rm /usr/share/cursors/${X11_IMPLEM}/*

	dodir /usr/share/cursors/${X11_IMPLEM}/Grounation/cursors/
	cp -d  ${S}/mouse/Grounation/cursors/* \
		${D}/usr/share/cursors/${X11_IMPLEM}/Grounation/cursors/

	dodir /usr/share/cursors/${X11_IMPLEM}/default
	cp -d ${S}/mouse/Grounation/index.theme \
		/usr/share/cursors/${X11_IMPLEM}/default/index.theme		

	# Kicker theme | only pics for now
	# /usr/kde/3.5/share/apps/kicker/pics/
	dodir ${ROOT}/$kdedir/share/apps/kicker/pics/
	cp -d ${S}/kicker/pics/* \
		${ROOT}/$kdedir/share/apps/kicker/pics/

}
