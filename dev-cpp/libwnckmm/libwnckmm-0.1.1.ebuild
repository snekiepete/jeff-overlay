# Distributed under the terms of the GNU General Public License v2
EAPI=8

DESCRIPTION="C++ bindings for libwnck (provides wnckmm-1.0.pc)"
HOMEPAGE="https://tracker.debian.org/pkg/libwnckmm"
SRC_URI="https://mirror.esecuredata.com/ubuntu-archive/pool/universe/libw/libwnckmm/libwnckmm_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	virtual/pkgconfig
	dev-build/libtool
	dev-perl/XML-Parser
	doc? (
		app-doc/doxygen
		app-text/graphviz
		app-text/xmlto
		dev-libs/libxslt
	)
"
RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	x11-libs/libwnck:1
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libwnckmm-1.0-${PV}"

src_configure() {
	local myeconf=( --disable-static )
	use doc || myeconf+=( --disable-documentation --disable-doxygen )
	econf "${myeconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	# Only install docs that actually exist
	local docs=( AUTHORS ChangeLog NEWS README README.md COPYING )
	local have=()
	for f in "${docs[@]}"; do
		[[ -f ${f} ]] && have+=( "${f}" )
	done
	((${#have[@]})) && dodoc "${have[@]}" || :
}
