# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Collection of plug-ins for Cairo-Dock"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-plug-ins"
SRC_URI="https://github.com/Cairo-Dock/cairo-dock-plug-ins/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# Repo ships GPL-3 LICENSE; plugin set contains mixed licensing across modules.
LICENSE="GPL-3 LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa ical gmenu gnome impulse indicator dbusmenu python"

DEPEND="
	>=x11-misc/cairo-dock-core-3.6.0
	>=dev-libs/glib-2.36:2
	dbusmenu? (
		|| ( dev-libs/libdbusmenu[gtk3] dev-libs/libdbusmenu )
	)
	indicator? ( || ( dev-libs/libayatana-indicator dev-libs/libindicator ) )
	alsa? ( media-libs/alsa-lib )
	ical? ( dev-libs/libical )
	gmenu? ( gnome-base/gnome-menus )
	impulse? ( media-libs/libpulse )
	python? ( dev-lang/python:3.11 )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}"

src_configure() {
	local mycmakeargs=(
		-Denable-alsa-mixer=$(usex alsa TRUE FALSE)
		-Denable-ical-support=$(usex ical TRUE FALSE)
		-Denable-gmenu=$(usex gmenu TRUE FALSE)
		-Denable-gnome-integration=$(usex gnome TRUE FALSE)
		-Denable-impulse=$(usex impulse TRUE FALSE)
		-Denable-dbusmenu-support=$(usex dbusmenu TRUE FALSE)
		-Denable-indicator-support=$(usex indicator TRUE FALSE)
		-Denable-python-interface=$(usex python TRUE FALSE)
	)
	cmake_src_configure
}
