# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3 xdg

DESCRIPTION="A highly configurable terminal emulator (VTE-based)"
HOMEPAGE="https://github.com/realh/roxterm"
EGIT_REPO_URI="https://github.com/realh/roxterm.git"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-3.20:3
	>=x11-libs/vte-0.48:2.91
	sys-apps/dbus
	dev-libs/dbus-glib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( README.md NEWS )

src_prepare() {
	cmake_src_prepare

	# Some projects generate a version file from git tags; roxterm has helper scripts.
	# If upstream ever requires it, uncomment the following:
	# ./version.sh || die
}

src_configure() {
	local mycmakeargs=(
		# Keep this conservative (unknown options would break the build).
		# If you find upstream CMake options for NLS, we can wire them here.
	)
	cmake_src_configure
}