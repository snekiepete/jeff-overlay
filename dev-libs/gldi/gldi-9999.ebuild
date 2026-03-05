EAPI=8
inherit git-r3 cmake
DESCRIPTION="GLDI (Cairo-Dock core library)"
HOMEPAGE="https://gitlab.com/cairo-dock/cairo-dock-core"
EGIT_REPO_URI="https://github.com/Cairo-Dock/cairo-dock-core.git"
LICENSE="GPL-3"
SLOT="0"
IUSE="opengl"
DEPEND="dev-libs/glib:2 x11-libs/gtk+:3 x11-libs/cairo x11-libs/pango
        x11-libs/gdk-pixbuf:2 gnome-base/librsvg x11-libs/libX11
        x11-libs/libXrender x11-libs/libXrandr x11-libs/libXinerama
        x11-libs/libXcomposite dev-libs/libxml2 sys-apps/dbus
        virtual/pkgconfig"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
src_configure() {
  local mycmakeargs=(
    -DCMAKE_INSTALL_PREFIX=/usr
    -DENABLE_GTK3=ON
    -DENABLE_OPENGL=$(usex opengl ON OFF)
    -DENABLE_GLES=OFF -DENABLE_WAYLAND=OFF -DENABLE_DEBUG=OFF
  )
  cmake_src_configure
}
src_install(){ cmake_src_install; einstalldocs; }
