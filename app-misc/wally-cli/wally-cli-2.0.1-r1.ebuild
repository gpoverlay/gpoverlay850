# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module udev

DESCRIPTION="Flash your ZSA Keyboard the EZ way"
HOMEPAGE="https://github.com/zsa/wally-cli"
SRC_URI="https://github.com/zsa/${PN}/archive/refs/tags/${PV}-linux.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~ajak/dist/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S="${WORKDIR}/${P}-linux"

LICENSE="Apache-2.0 BSD BSD-4 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md license.md )

DEPEND="dev-libs/libusb:1"
RDEPEND="
	acct-group/plugdev
	${DEPEND}
"

src_compile() {
	ego build
}

src_install() {
	default
	dobin wally-cli

	udev_dorules "${FILESDIR}"/50-zsa.rules
	elog "To use ${PN} as a user, you must be in the plugdev group"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
