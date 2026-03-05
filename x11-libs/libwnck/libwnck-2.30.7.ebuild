# Distributed under the terms of the GNU General Public License v2
EAPI=8

DESCRIPTION="Window Navigator Construction Kit (GTK+2 branch, slot 1)"
HOMEPAGE="https://developer.gnome.org/libwnck/"
# Old GTK2 series; 2.30.7 is a common final tarball
SRC_URI="https://download.gnome.org/sources/libwnck/2.30/libwnck-${PV}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="startup-notification"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	dev-util/intltool
"
RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/gdk-pixbuf:2
	startup-notification? ( x11-libs/startup-notification )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libwnck-${PV}"

src_configure() {
	econf \
		--disable-static \
		--disable-gtk-doc \
		$(use_with startup-notification)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
