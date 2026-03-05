# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Collection of plug-ins for Cairo-Dock"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-plug-ins"
SRC_URI="https://github.com/Cairo-Dock/cairo-dock-plug-ins/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus gmenu gnome pulseaudio vnc weather wifi"

DEPEND="
    >=x11-libs/gtk+-3.0:3
    >=x11-libs/cairo-1.10
    x11-libs/libX11
    x11-libs/libXrender
    x11-libs/libXcomposite
    x11-libs/libXdamage
    x11-libs/libXrandr
    x11-libs/libXinerama
    >=dev-libs/glib-2.28
    media-libs/mesa
    >=x11-libs/pango-1.20
    alsa? ( media-libs/alsa-lib )
    dbus? ( sys-apps/dbus )
    gmenu? ( gnome-base/gnome-menus )
    gnome? ( gnome-base/gnome-menus )
    pulseaudio? ( media-sound/pulseaudio )
    vnc? ( net-libs/libvncserver )
    weather? ( dev-libs/json-glib )
    wifi? ( net-wireless/wireless-tools )
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}"

src_configure() {
    local mycmakeargs=(
        -Denable-alsa=$(usex alsa)
        -Denable-dbus=$(usex dbus)
        -Denable-gnome-menus=$(usex gnome)
        -Denable-gmenu=$(usex gmenu)
        -Denable-pulseaudio=$(usex pulseaudio)
        -Denable-vnc=$(usex vnc)
        -Denable-weather=$(usex weather)
        -Denable-wifi=$(usex wifi)
    )

    cmake_src_configure
}
