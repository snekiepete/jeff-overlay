EAPI=8

inherit autotools git-r3

DESCRIPTION="Emerald window decorator for Compiz"
HOMEPAGE="https://github.com/snekiepete/emerald"
EGIT_REPO_URI="https://github.com/snekiepete/emerald.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk3"

RDEPEND="
	x11-wm/compiz
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libwnck:3
	x11-libs/startup-notification
	dev-libs/glib:2
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	dev-build/autoconf
	dev-build/automake
	dev-build/libtool
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk3)
}

src_install() {
	default

	local d
	for d in AUTHORS NEWS README README.md; do
		[[ -f ${d} ]] && dodoc "${d}"
	done
}
