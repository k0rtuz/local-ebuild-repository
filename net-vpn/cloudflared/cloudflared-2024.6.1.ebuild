# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Cloudflare Tunnel client (formerly Argo Tunnel)"
HOMEPAGE="https://github.com/cloudflare/cloudflared"
SRC_URI="https://github.com/cloudflare/cloudflared/releases/download/${PV}/${PN}-linux-amd64"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

S="${WORKDIR}"
MERGE_TYPE="binary"

src_unpack() {
    cp "${DISTDIR}"/${PN}-linux-amd64 "${WORKDIR}"
}

src_install() {
	einfo "$(ls ${S})"
	exeinto "/opt/${PN}"
	doexe "${PN}-linux-amd64"
	dosym "/opt/${PN}/${PN}-linux-amd64" "/opt/bin/${PN}"
}
