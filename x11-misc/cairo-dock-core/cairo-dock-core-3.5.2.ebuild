# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Core components of Cairo-Dock, a light and eye-candy dock"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-core"
SRC_URI="https://github.com/Cairo-Dock/cairo-dock-core/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio gnome"

DEPEND="
    >=dev-libs/glib-2.28
    >=x11-libs/gtk+-3.0:3
    >=x11-libs/cairo-1.10
    >=x11-libs/pango-1.20
    media-libs/mesa
    x11-libs/libX11
    x11-libs/libXrender
    x11-libs/libXcomposite
    x11-libs/libXdamage
    x11-libs/libXinerama
    x11-libs/libXrandr
    x11-libs/libXtst
    pulseaudio? ( media-sound/pulseaudio )
    gnome? ( gnome-base/gnome-menus )
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${PV}"

src_configure() {
    local mycmakeargs=(
        -Denable-pulseaudio=$(usex pulseaudio)
        -Denable-gnome-menus=$(usex gnome)
    )

    cmake_src_configure
}
