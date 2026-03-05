# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Desktop-independent power manager with D-Bus and logind support"
HOMEPAGE="https://github.com/rodlie/powerkit"
SRC_URI="https://github.com/rodlie/powerkit/releases/download/1.0.0/${P}.tar.xz"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icons xscreensaver"

DEPEND="
    dev-qt/qtcore:5
    dev-qt/qtgui:5
    dev-qt/qtwidgets:5
    dev-qt/qtx11extras:5
    x11-libs/libX11
    x11-libs/libXtst
    x11-libs/libXScrnSaver
    virtual/pkgconfig
"
RDEPEND="
    ${DEPEND}
    x11-apps/xrandr
    sys-power/upower
    sys-auth/polkit
    sys-apps/dbus
    x11-misc/xdg-utils
    icons? ( x11-themes/adwaita-icon-theme )
    xscreensaver? ( x11-misc/xscreensaver )
"

DOCS=( README.md LICENSE )

src_configure() {
    local qmake_args=()
    use icons || qmake_args+=(CONFIG+=bundle_icons)

    eqmake5 ${qmake_args[@]}
}

src_compile() {
    emake
}

src_install() {
    emake INSTALL_ROOT="${D}" install

    # Install .desktop if present
    if [[ -f "${S}/powerkit.desktop" ]]; then
        domenu "${S}/powerkit.desktop"
    fi

    # Install man page if present
    if [[ -f "${S}/powerkit.1" ]]; then
        doman "${S}/powerkit.1"
    fi

    einstalldocs
}

pkg_postinst() {
    elog "Powerkit supports screen locking via xscreensaver or xflock4."
    elog "You can enable the 'xscreensaver' USE flag or install a locker manually."
}
