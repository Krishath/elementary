# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION=0.16

inherit fdo-mime gnome2-utils vala cmake-utils

DESCRIPTION="Stylish top panel that holds indicators and spawns an application launcher"
HOMEPAGE="https://launchpad.net/wingpanel"
SRC_URI="https://code.launchpad.net/~elementary-os/+archive/daily/+files/wingpanel_0.3%7Er154%2Bpkg16%2Br1%7Eubuntu14.04.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth power sound nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgee:0
	dev-libs/libindicator:3
	x11-libs/gtk+:3
	<x11-libs/granite-0.3
	x11-libs/libido:3
	x11-libs/libX11"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
PDEPEND="
	>=x11-misc/indicator-datetime-13.10.0_p20131023
	>=x11-misc/indicator-session-12.10.5_p20131125
	bluetooth? ( >=net-misc/indicator-bluetooth-0.0.6_p20131029 )
	power? ( >=sys-power/indicator-power-12.10.6_p20131129 )
	sound? ( >=media-sound/indicator-sound-12.10.2_p20131125 )"

DOCS=( "${S}/AUTHORS" "${S}/COPYING" "${S}/COPYRIGHT" )

src_unpack() {
	default_src_unpack

	mv "${WORKDIR}/recipe-{debupstream}~r{revno}+pkg{revno:packaging}+r1" "${S}"
}

src_prepare() {
	epatch_user

	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cmake-utils_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_schemas_update
}

