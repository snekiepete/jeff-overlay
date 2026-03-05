EAPI=8

inherit autotools

DESCRIPTION="Emerald window decorator for Compiz"
HOMEPAGE="https://github.com/snekiepete/Emerald"
SRC_URI="https://github.com/snekiepete/Emerald/raw/main/emerald-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/emerald-v${PV}"

BDEPEND="
    dev-build/autoconf
    dev-build/automake
    dev-build/libtool
"
DEPEND="
    x11-libs/gtk+:2
    x11-libs/libXrender
    x11-libs/libXcomposite
    x11-libs/libXdamage
    x11-libs/libwnck
"
RDEPEND="${DEPEND}"

src_prepare() {
    default
    eautoreconf
}

src_configure() {
    econf --prefix=/usr/local
}

src_compile() {
    emake
}

src_install() {
    default
}
