# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Official plug-ins for Cairo-Dock"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-plug-ins"
EGIT_REPO_URI="https://github.com/Cairo-Dock/cairo-dock-plug-ins.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="alsa dbus gmenu mail networkmanager terminal weather webkit xfce"

RDEPEND="
	x11-misc/cairo-dock-core
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/pango

	alsa? ( media-libs/alsa-lib )
	dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)
	gmenu? ( gnome-base/gnome-menus:3 )
	mail? (
		net-libs/libetpan
	)
	networkmanager? ( net-misc/networkmanager )
	terminal? ( x11-libs/vte:2.91 )
	weather? (
		dev-libs/libxml2
		net-misc/curl
	)
	webkit? ( net-libs/webkit-gtk:4.1 )
	xfce? ( xfce-base/thunar )
"

DEPEND="${RDEPEND}"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare

	local f

	for f in \
		weather/src/applet-config.c \
		weather/src/applet-read-data.c \
		weather/src/applet-load-icons.c
	do
		if [[ -f ${f} ]] && ! grep -q '#include <math.h>' "${f}" ; then
			sed -i '1i#include <math.h>' "${f}" || die
		fi
	done
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release

		# Plug-ins need to find the Portage-installed cairo-dock-core.
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr"

		-Denable-alsaMixer=$(usex alsa True False)
		-Denable-dbus=$(usex dbus True False)
		-Denable-GMenu=$(usex gmenu True False)
		-Denable-mail=$(usex mail True False)
		-Denable-network-monitor=$(usex networkmanager True False)
		-Denable-terminal=$(usex terminal True False)
		-Denable-weather=$(usex weather True False)
		-Denable-weblets=$(usex webkit True False)
		-Denable-xfce-integration=$(usex xfce True False)
	)

	cmake_src_configure
}
