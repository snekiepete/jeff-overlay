EAPI=8

inherit git-r3 linux-info

DESCRIPTION="TUXEDO Computers kernel module drivers"
HOMEPAGE="https://github.com/tuxedocomputers/tuxedo-drivers"
EGIT_REPO_URI="https://github.com/tuxedocomputers/tuxedo-drivers.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"

pkg_setup() {
	linux-info_pkg_setup
}

src_compile() {
	emake ARCH=x86 KDIR="${KV_OUT_DIR}" KERNEL_DIR="${KV_OUT_DIR}"
}

src_install() {
	local moddir="/lib/modules/${KV_FULL}/updates/tuxedo"
	local ko

	insinto "${moddir}"

	while IFS= read -r -d '' ko; do
		doins "${ko}" || die "failed installing ${ko}"
	done < <(find "${S}" -type f -name '*.ko' -print0)

	depmod -b "${D}" "${KV_FULL}" || die
}