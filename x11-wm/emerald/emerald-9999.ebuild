# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit autotools git-r3 flag-o-matic

DESCRIPTION="Emerald - Compiz 0.8 window decorator (Compiz Reloaded fork)"
HOMEPAGE="https://github.com/compiz-reloaded/emerald"
EGIT_REPO_URI="https://github.com/compiz-reloaded/emerald.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls themer"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool
"

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/pango
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXrender
	x11-wm/compiz
	themer? (
		dev-cpp/gtkmm:2.4
		x11-libs/libwnck:1
		dev-cpp/libwnckmm:1
	)
"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	# Make old code happy on new compilers without turning warnings into errors
	sed -i -e 's/-Werror//g' configure.ac Makefile.am */Makefile.am 2>/dev/null || :
	# Regenerate build system
	eautoreconf
}

src_configure() {
	local myeconf=()
	use nls    || myeconf+=( --disable-nls )
	use themer || myeconf+=( --disable-themer )

	# GTK2/gtkmm-2.x-era code compiles most smoothly with gnu++11 + relaxed warnings
	append-cxxflags -std=gnu++11 -Wno-deprecated-declarations -Wno-deprecated-copy -fpermissive

	econf "${myeconf[@]}" --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog NEWS README || :
}
