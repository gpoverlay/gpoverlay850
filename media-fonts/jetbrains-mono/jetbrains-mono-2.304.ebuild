# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="A free and open-source typeface for developers"
HOMEPAGE="https://www.jetbrains.com/lp/mono/"
SRC_URI="https://github.com/JetBrains/JetBrainsMono/releases/download/v${PV}/JetBrainsMono-${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/fonts/ttf"
FONT_SUFFIX="ttf"
