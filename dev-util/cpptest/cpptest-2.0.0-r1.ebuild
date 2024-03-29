# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple but powerful unit testing framework for C++"
HOMEPAGE="https://github.com/cpptest/cpptest"
SRC_URI="https://github.com/cpptest/cpptest/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"  # for soversion 1.x.x
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="doc"

RDEPEND="!dev-util/cpptest:0"
BDEPEND="doc? ( app-text/doxygen )"

DOCS=( AUTHORS BUGS NEWS README )

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
