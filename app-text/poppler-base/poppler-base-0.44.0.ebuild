# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_WARN_UNUSED_CLI=1
inherit cmake-utils toolchain-funcs xdg-utils
DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="https://poppler.freedesktop.org/"
SRC_URI="https://poppler.freedesktop.org/${P/-base}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~arm"
SLOT="0/61"
IUSE="cjk curl cxx debug doc +jpeg jpeg2k +lcms nss png tiff +utils"

# No test data provided
RESTRICT="test"

COMMON_DEPEND="
	>=media-libs/fontconfig-2.6.0
	>=media-libs/freetype-2.3.9
	sys-libs/zlib
	curl? ( net-misc/curl )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/openjpeg:2= )
	lcms? ( media-libs/lcms:2 )
	nss? ( >=dev-libs/nss-3.19:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	cjk? ( >=app-text/poppler-data-0.4.7 )
"

DOCS=(AUTHORS NEWS README README-XPDF TODO)

PATCHES=(
	"${FILESDIR}/qt5-dependencies.patch"
	"${FILESDIR}/fix-multilib-configuration.patch"
	"${FILESDIR}/respect-cflags.patch"
	"${FILESDIR}/openjpeg2.patch"
	"${FILESDIR}/FindQt4.patch"
)

S="${WORKDIR}/${P/-base}"

src_prepare() {
	cmake-utils_src_prepare

	# Clang doesn't grok this flag, the configure nicely tests that, but
	# cmake just uses it, so remove it if we use clang
	if [[ ${CC} == clang ]] ; then
		sed -i -e 's/-fno-check-new//' cmake/modules/PopplerMacros.cmake || die
	fi

}

src_configure() {
	xdg_environment_reset
	local mycmakeargs=(
		-DBUILD_GTK_TESTS=OFF
		-DBUILD_QT4_TESTS=OFF
		-DBUILD_QT5_TESTS=OFF
		-DBUILD_CPP_TESTS=OFF
		-DENABLE_SPLASH=ON
		-DENABLE_ZLIB=ON
		-DENABLE_ZLIB_UNCOMPRESS=OFF
		-DENABLE_XPDF_HEADERS=ON
		-DENABLE_LIBCURL="$(usex curl)"
		-DENABLE_CPP="$(usex cxx)"
		-DENABLE_UTILS="$(usex utils)"
		-DSPLASH_CMYK=OFF
		-DUSE_FIXEDPOINT=OFF
		-DUSE_FLOAT=OFF
		-DWITH_Cairo=OFF
		-DWITH_GObjectIntrospection=OFF
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_NSS3="$(usex nss)"
		-DWITH_PNG="$(usex png)"
		-DWITH_Qt4=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Core=ON
		-DQT5_FOUND=OFF
		-DWITH_TIFF="$(usex tiff)"
	)
	if use jpeg2k; then
		mycmakeargs+=(-DENABLE_LIBOPENJPEG=openjpeg2)
	else
		mycmakeargs+=(-DENABLE_LIBOPENJPEG=)
	fi
	if use lcms; then
		mycmakeargs+=(-DENABLE_CMS=lcms2)
	else
		mycmakeargs+=(-DENABLE_CMS=)
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
