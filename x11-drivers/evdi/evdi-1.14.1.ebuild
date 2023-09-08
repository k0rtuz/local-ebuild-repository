# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Extensible Virtual Display Interface"
HOMEPAGE="https://github.com/DisplayLink/evdi"
SRC_URI="https://github.com/DisplayLink/evdi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

RDEPEND="x11-libs/libdrm"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

#CONFIG_CHECK="~FB_VIRTUAL ~!INTEL_IOMMU"
CONFIG_CHECK="~FB_VIRTUAL ~I2C"

pkg_setup() {
	linux-mod-r1_pkg_setup
}

src_compile() {
	local modlist=(
		"evdi=video:module"
	)
	linux-mod-r1_src_compile
	cd "${S}/library"
	default
	mv libevdi.so libevdi.so.0
}

src_install() {
	linux-mod-r1_src_install
	dolib.so library/libevdi.so.0
	dosym libevdi.so.0 "/usr/$(get_libdir)/libevdi.so"
}

pkg_postinst() {
	einfo "The EVDI library was successfully installed."
}
