EAPI=8

inherit git-r3

DESCRIPTION="TUXEDO kernel sources (tuxedo-6.14-24.04 branch)"
HOMEPAGE="https://gitlab.com/tuxedocomputers/development/packages/linux"
EGIT_REPO_URI="https://gitlab.com/tuxedocomputers/development/packages/linux.git"
EGIT_BRANCH="tuxedo-6.14-24.04"

LICENSE="GPL-2"
SLOT="6.14"
KEYWORDS=""
IUSE=""
RESTRICT="strip"

S="${WORKDIR}/${P}"

src_unpack() {
    git-r3_src_unpack
    [[ -d ${S} ]] || die "Kernel tree not found at ${S}"
}

src_prepare() {
    default
    eapply_user
}

src_compile() {
    :
}

src_install() {
    local dest="/usr/src/linux-${PV}-tuxedo"

    dodir /usr/src || die
    cp -a "${S}" "${ED}${dest}" || die

    rm -rf "${ED}${dest}/.git" || die

    dosym "linux-${PV}-tuxedo" /usr/src/linux-tuxedo
}

pkg_postinst() {
    einfo "Installed TUXEDO sources to /usr/src/linux-${PV}-tuxedo"
}
