# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Firmware and scripts for controlling the Portapack from Sharebrained"
HOMEPAGE="https://github.com/sharebrained/portapack-hackrf/releases"
SRC_URI="https://github.com/sharebrained/portapack-hackrf/releases/download/${PV}/portapack-h1-firmware-${PV}.tar.bz2"
S="${WORKDIR}/portapack-h1-firmware-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PDEPEND=">=net-wireless/hackrf-tools-2015.07.2-r1
	>=app-mobilephone/dfu-util-0.7"

src_install() {
	insinto /usr/share/hackrf
	newins portapack-h1-firmware.bin portapack-h1-firmware-${PV}.bin
	ln -s portapack-h1-firmware-${PV}.bin "${ED}/usr/share/hackrf/portapack-h1-firmware.bin" || die
}
