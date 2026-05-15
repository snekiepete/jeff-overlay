EAPI=8

inherit git-r3

DESCRIPTION="TUXEDO Linux kernel sources (live)"
HOMEPAGE="https://github.com/tuxedocomputers/linux"
EGIT_REPO_URI="https://gitlab.com/tuxedocomputers/development/packages/linux.git"
EGIT_BRANCH="tuxedo-6.17-24.04"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default
}

src_compile() {
	# Nothing to compile for sources
	return 0
}

src_install() {
	# Try to get kernel version from source
	local kver
	kver="$(make -s kernelrelease 2>/dev/null)"

	# Fallback if detection fails
	if [[ -z "${kver}" ]]; then
		kver="6.17.0"
	fi

	local dest="/usr/src/linux-${kver}-tuxedo"

	einfo "Installing TUXEDO kernel sources to ${dest}"

	dodir "${dest}" || die

	# Copy full source tree
	cp -a . "${ED}${dest}" || die "Failed to copy sources"

	# Permissions cleanup (important for build tools)
	find "${ED}${dest}" -type f -exec chmod 0644 {} + || die
	find "${ED}${dest}" -type d -exec chmod 0755 {} + || die

	# Ensure scripts are executable
	if [[ -d "${ED}${dest}/scripts" ]]; then
		find "${ED}${dest}/scripts" -type f -exec chmod +x {} + || die
	fi

	# DO NOT create /usr/src/linux symlink here
	# eselect kernel should manage it
}

pkg_postinst() {
	elog ""
	elog "TUXEDO kernel sources installed."
	elog ""
	elog "Next steps:"
	elog "  eselect kernel list"
	elog "  eselect kernel set <number>"
	elog ""
	elog "Then copy your working config:"
	elog "  cp /boot/config-6.17.0-111019-tuxedo /usr/src/linux/.config"
	elog ""
	elog "Then build using your update-kernel script."
	elog ""
}
