EAPI=8

inherit cmake

DESCRIPTION="Core components of Cairo-Dock, a light and eye-candy dock"
HOMEPAGE="https://github.com/Cairo-Dock/cairo-dock-core"
SRC_URI="https://github.com/Cairo-Dock/cairo-dock-core/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="wayland systemd egl glx"

DEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/cairo
	x11-libs/pango
	gnome-base/librsvg:2
	sys-apps/dbus
	dev-libs/dbus-glib
	dev-libs/libxml2
	net-misc/curl
	virtual/opengl
	media-libs/glu

	wayland? (
		dev-libs/wayland
		gui-libs/gtk-layer-shell:0
		kde-frameworks/extra-cmake-modules
	)
"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-Denable-wayland-support=$(usex wayland ON OFF)
		-Denable-egl-support=$(usex egl ON OFF)
		-Denable-glx-support=$(usex glx ON OFF)
		-Denable-systemd-service=$(usex systemd TRUE FALSE)
	)
	cmake_src_configure
}
