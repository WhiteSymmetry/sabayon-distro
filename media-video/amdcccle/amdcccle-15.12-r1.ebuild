# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator

DESCRIPTION="AMD Catalyst Control Center Linux Edition"
HOMEPAGE="http://www.amd.com"
SLOT="1"
BUILD_VER=15.302
RUN="${WORKDIR}/fglrx-${BUILD_VER}/amd-driver-installer-${BUILD_VER}-x86.x86_64.run"
DRV_VER="radeon-crimson-${PV}-${BUILD_VER}-151217a-297685e.zip"
DRIVERS_URI="mirror://gentoo/${DRV_VER}"
SDK_VER="xvba-sdk-0.74-404001.tar.gz"
XVBA_SDK_URI="http://developer.amd.com/wordpress/media/2012/10/${SDK_VER}"
SRC_URI="${DRIVERS_URI} ${XVBA_SDK_URI}"
FOLDER_PREFIX="common/"
IUSE=""

LICENSE="QPL-1.0 as-is"
KEYWORDS="~amd64 ~x86"

RDEPEND="~x11-drivers/ati-drivers-${PV}
	~x11-drivers/ati-userspace-${PV}
	dev-qt/qtcore:4
	dev-qt/qtgui:4"

DEPEND=""
S="${WORKDIR}"

QA_EXECSTACK="opt/bin/amdcccle"

src_unpack() {
	local DRIVERS_DISTFILE XVBA_SDK_DISTFILE
	DRIVERS_DISTFILE=${DRIVERS_URI##*/}
	XVBA_SDK_DISTFILE=${XVBA_SDK_URI##*/}

	if [[ ${DRIVERS_DISTFILE} =~ .*\.tar\.gz ]]; then
		unpack ${DRIVERS_DISTFILE}
                mkdir -p common
                mv etc lib usr common || die "Assumed to find etc lib and usr for common"
	else
		#please note, RUN may be insanely assigned at top near SRC_URI
		if [[ ${DRIVERS_DISTFILE} =~ .*\.zip ]]; then
			unpack ${DRIVERS_DISTFILE}
			[[ -z "$RUN" ]] && RUN="${S}/${DRIVERS_DISTFILE/%.zip/.run}"
		else
			RUN="${DISTDIR}/${DRIVERS_DISTFILE}"
		fi
		sh ${RUN} --extract "${S}" 2>&1 > /dev/null || die
	fi

	mkdir xvba_sdk
	cd xvba_sdk
	unpack ${XVBA_SDK_DISTFILE}
}

src_compile() {
	echo
}

src_install() {
	insinto /usr/share
	doins -r ${FOLDER_PREFIX}usr/share/ati
	insinto /usr/share/pixmaps
	doins ${FOLDER_PREFIX}usr/share/icons/ccc_large.xpm
	make_desktop_entry amdcccle 'ATI Catalyst Control Center' \
		ccc_large System

	use x86 && ARCH_BASE="x86"
	use amd64 && ARCH_BASE="x86_64"
        into /opt
        dobin arch/${ARCH_BASE}/usr/X11R6/bin/amdcccle
	dosbin arch/${ARCH_BASE}/usr/sbin/amdnotifyui
}
