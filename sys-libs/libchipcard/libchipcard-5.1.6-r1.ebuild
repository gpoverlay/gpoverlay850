# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for accessing chip cards via chip card readers (terminals)"
HOMEPAGE="https://www.aquamaniac.de/rdm/projects/libchipcard"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/382/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="doc examples"

BDEPEND="
	sys-devel/gettext
	doc? ( app-text/doxygen )
"
DEPEND="
	>=sys-apps/pcsc-lite-1.6.2
	>=sys-libs/gwenhywfar-4.99.22_rc6:=
	sys-libs/zlib
	virtual/libintl
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO doc/{CERTIFICATES,CONFIG,IPCCOMMANDS} )

PATCHES=(
	"${FILESDIR}"/${P}-clang16-build-fix.patch
)

src_configure() {
	local myeconfargs=(
		--disable-static
		--with-docpath=/usr/share/doc/"${PF}"/apidoc
		$(use_enable doc full-doc)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	einstalldocs

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h,xml} tutorials/README
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
