# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="Build your personal knowledge base with Trilium Notes"
HOMEPAGE="https://github.com/zadam/trilium"
SRC_URI="https://github.com/zadam/trilium/releases/download/v0.63.7/${PN}-linux-x64-${PVR}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

S="${WORKDIR}/${PN}-linux-x64"
MERGE_TYPE="binary"

src_install() {
	insinto "/opt/${PN}"
	doins -r dump-db
	doins -r locales
	doins -r resources
	doins *.sql
	doins *.png
	doins *.dat
	doins LICENSE*
	doins *.pak
	doins *.bin
	doins v*
	exeinto "/opt/${PN}"
	doexe chrome-sandbox
	doexe chrome_crashpad_handler
	doexe *.so
	doexe *.so.1
	doexe trilium*
	exeinto "/opt/${PN}/dump-db"
	doexe dump-db/dump-db.js
	dosym "/opt/${PN}/${PN}" "/opt/bin/${PN}"
}
