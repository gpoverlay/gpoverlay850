# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="ZThread-${PV}"

DESCRIPTION="platform-independent multi-threading and synchronization library for C++"
HOMEPAGE="http://zthread.sourceforge.net/"
SRC_URI="mirror://sourceforge/zthread/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~mips ppc ~sparc x86"
IUSE="debug doc"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-no-fpermissive-r1.diff
	"${FILESDIR}"/${P}-m4-quote.patch
	"${FILESDIR}"/${P}-automake-r2.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
)

src_prepare() {
	default

	rm -f include/zthread/{.Barrier.h.swp,Barrier.h.orig} || die

	# bug #467778
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die

	AT_M4DIR="share" eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable kernel_linux atomic-linux)
}

src_compile() {
	default

	if use doc; then
		doxygen doc/zthread.doxygen || die
		sed -i -e 's|href="html/|href="|' doc/documentation.html || die
		cp doc/documentation.html doc/html/index.html || die
		cp doc/{zthread.css,bugs.js} doc/html/ || die
	fi
}

src_install() {
	default

	use doc && dodoc -r doc/html

	find "${ED}" -name '*.la' -delete || die
}
