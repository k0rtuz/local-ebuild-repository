# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="DisplayLink USB Graphics Software"
HOMEPAGE="http://www.displaylink.com/downloads/ubuntu"
SRC_URI="https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu${PV}-EXE.zip"

LICENSE="DisplayLink-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
PV_EXTRA="63.33"

RESTRICT="mirror bindist"

DEPEND="app-admin/chrpath
	app-arch/unzip"
RDEPEND=">=sys-devel/gcc-12.3.1
	>=x11-drivers/evdi-1.14.1
	virtual/libusb:1
	>=x11-base/xorg-server-21.1.8
	sys-auth/elogind
	virtual/udev"

src_unpack() {
	default
	sh ./"${PN}-driver-${PV}.0-${PV_EXTRA}".run --noexec --target "${P}"
}

src_configure() {
	econf --with-rulesdir="$(get_udevdir)"/rules.d
}

src_install() {
	MY_UBUNTU_VERSION=1604
	einfo "Using package for Ubuntu ${MY_UBUNTU_VERSION}"

	case "${ARCH}" in
		amd64)	MY_ARCH="x64" ;;
		*)		MY_ARCH="${ARCH}" ;;
	esac
	DLM="${S}/${MY_ARCH}-ubuntu-${MY_UBUNTU_VERSION}/DisplayLinkManager"

	dodir /opt/displaylink
	dodir /var/log/displaylink

	exeinto /opt/displaylink
	chrpath -d "${DLM}"
	doexe "${DLM}"

	insinto /opt/displaylink
	doins *.spkg

	udev_dorules "${FILESDIR}/99-displaylink.rules"

	insinto /opt/displaylink
	insopts -m0755
	newins "${FILESDIR}/udev.sh" udev.sh
	newins "${FILESDIR}/elogind-hook" displaylink

	dosym ../../../opt/displaylink/displaylink.sh /lib64/elogind/system-sleep/50-displaylink.sh
	newinitd "${FILESDIR}/rc-displaylink-1.3" dlm
}

pkg_postinst() {
	einfo "The DisplayLinkManager Init is now called dlm"
	einfo ""
	einfo "You should be able to use xrandr as follows:"
	einfo "xrandr --setprovideroutputsource 1 0"
	einfo "Repeat for more screens, like:"
	einfo "xrandr --setprovideroutputsource 2 0"
	einfo "Then, you can use xrandr or GUI tools like arandr to configure the screens, e.g."
	einfo "xrandr --output DVI-1-0 --auto"
}
