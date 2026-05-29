# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="Light and eye-candy dock to launch programs easily"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-core"
EGIT_REPO_URI="https://github.com/Cairo-Dock/cairo-dock-core.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="debug egl glx gnome gtk-layer-shell systemd wayland wayland-protocols X"

REQUIRED_USE="
	glx? ( X )
	wayland-protocols? ( wayland )
	gtk-layer-shell? ( wayland )
	|| ( X wayland )
"

RDEPEND="
	dev-libs/glib:2
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libwnck:3
	x11-libs/pango

	egl? ( media-libs/libglvnd )
	glx? ( media-libs/libglvnd )

	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXtst
	)

	wayland? ( dev-libs/wayland )
	wayland-protocols? ( dev-libs/wayland-protocols )
	gtk-layer-shell? ( gui-libs/gtk-layer-shell )

	gnome? ( gnome-base/gnome-session )
	systemd? ( sys-apps/systemd )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)

		-Denable-desktop-manager=$(usex gnome True False)
		-Denable-systemd-service=$(usex systemd True False)
		-Dgnome-session-use-systemd=$(usex gnome $(usex systemd True False) False)

		-Denable-wayland-support=$(usex wayland True False)
		-Denable-wayland-protocols=$(usex wayland-protocols True False)
		-Denable-egl-support=$(usex egl True False)

		-Denable-x11-support=$(usex X True False)
		-Denable-glx-support=$(usex glx True False)

		-Denable-gtk-layer-shell=$(usex gtk-layer-shell True False)

		-Dplugins-prefix="${EPREFIX}/usr"
	)

	cmake_src_configure
}
