# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs autotools

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
SRC_URI="
	http://www.mico.org/${P}.tar.gz
	https://github.com/ssi-schaefer/mico/compare/${PV}-raw...${PV}-gentoo-${PR}.patch -> ${P}-gentoo-${PR}.patch
"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="gtk postgres ssl tcl threads X"
RESTRICT="test" #298101

# doesn't compile:
#   bluetooth? ( net-wireless/bluez )

RDEPEND="
	gtk?       ( x11-libs/gtk+:2 )
	postgres?  ( dev-db/postgresql:* )
	ssl?       ( dev-libs/openssl:0= )
	tcl?       ( dev-lang/tcl:0 )
	X?         ( x11-libs/libXt )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	>=sys-devel/bison-1.22
"

PATCHES=(
	"${DISTDIR}"/${P}-gentoo-${PR}.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die #426262
	eautoreconf

	# cannot use big TOC (AIX only), gdb doesn't like it.
	# This assumes that the compiler (or -wrapper) uses
	# gcc flag '-mminimal-toc' for compilation.
	sed -i -e 's/,-bbigtoc//' "${S}"/configure || die
}

src_configure() {
	tc-export CC CXX
	append-cxxflags -fno-strict-aliasing

	# Don't know which version of JavaCUP would suffice, but there is no
	# configure argument to disable checking for JavaCUP.
	# So we override the configure check to not find 'javac'.
	export ac_cv_path_JAVAC=no

	# '--without-ssl' just does not add another search path - the only way
	# to disable openssl utilization seems to override the configure check.
	use ssl || export ac_cv_lib_ssl_open=no

	local myconf=
	myconf() {
		myconf="${myconf} $*"
	}

	myconf --disable-mini-stl
	myconf $(use_enable threads)

	# '--without-*' or '--with-*=no' does not disable some features,
	# the value needs to be empty instead.
	# This applies to: pgsql, qt, tcl, bluetooth.
	myconf --with-pgsql=$(use postgres && echo "${EPREFIX}"/usr)
	myconf --with-tcl=$(  use tcl      && echo "${EPREFIX}"/usr)
	# bluetooth and wireless both don't compile cleanly
	myconf --with-bluetooth=''
	myconf --disable-wireless
	# But --without-x works.
	myconf $(use_with X x "${EPREFIX}"/usr)
	# Same for gtk after patch 013, searches for gtk release.
	myconf $(use_with gtk gtk 2)

	econf ${myconf}
}

src_install() {
	emake INSTDIR="${ED}"/usr SHARED_INSTDIR="${ED}"/usr install LDCONFIG=:
	if [[ $(get_libdir) != lib ]]; then #500744
		mv "${ED}"/usr/lib "${ED}"/usr/$(get_libdir) || die
	fi

	# avoid conflict with net-dns/nsd, bug#544488
	mv "${ED}"/usr/bin/{,mico-}nsd || die
	mv "${ED}"/usr/man/man8/{,mico-}nsd.8 || die

	# avoid conflict with net-misc/eventd, bug#632170
	mv "${ED}"/usr/bin/{,mico-}eventd || die

	dodir /usr/share
	mv "${ED}"/usr/man "${ED}"/usr/share || die
	dodir /usr/share/doc/${PF}
	mv "${ED}"/usr/doc "${ED}"/usr/share/doc/${PF} || die

	dodoc BUGS CHANGES* CONVERT README* ROADMAP TODO VERSION WTODO
	dodoc FAQ
}

pkg_postinst() {
	einfo "The MICO Name Service daemon 'nsd' is named 'mico-nsd'"
	einfo "due to a name conflict with net-dns/nsd. For details"
	einfo "please refer to https://bugs.gentoo.org/544488."
	einfo
	einfo "The MICO Event daemon 'eventd' is named 'mico-eventd'"
	einfo "due to a name conflict with net-misc/eventd. For details"
	einfo "please refer to https://bugs.gentoo.org/632170."
}
