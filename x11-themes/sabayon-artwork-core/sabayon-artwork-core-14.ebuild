# Copyright 1999-2015 Sabayon
# Distributed under the terms of the GNU General Public License v2
#

EAPI=5
inherit eutils mount-boot sabayon-artwork

DESCRIPTION="Official Sabayon Linux Core Artwork"
HOMEPAGE="http://www.sabayon.org/"
SRC_URI="mirror://sabayon/${CATEGORY}/${PN}/${PN}-${PVR}.tar.xz"
LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~arm ~x86 ~amd64"
IUSE=""
RDEPEND="
	sys-apps/findutils
	x11-themes/sabayon-artwork-plymouth-default
	x11-themes/sabayon-artwork-grub
	x11-themes/sabayon-artwork-wallpapers
"

S="${WORKDIR}/${PN}"

src_install() {
	# Cursors
	cd "${S}"/mouse/entis/cursors || die
	dodir /usr/share/cursors/xorg-x11/entis/cursors
	insinto /usr/share/cursors/xorg-x11/entis/cursors
	doins -r ./
}

pkg_postinst() {
	# mount boot first
	mount-boot_mount_boot_partition

	einfo "Please report bugs or glitches to"
	einfo "http://bugs.sabayon.org"
}
