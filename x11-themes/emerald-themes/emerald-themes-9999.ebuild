# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit git-r3

DESCRIPTION="A collection of themes for the Emerald Compiz window decorator"
HOMEPAGE="https://github.com/compiz-reloaded/emerald-themes"
EGIT_REPO_URI="https://github.com/compiz-reloaded/emerald-themes.git"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE=""
KEYWORDS=""

RDEPEND="x11-wm/emerald"
DEPEND=""

# No configure/compile: avoid upstream Makefiles that call chmod on missing dirs
src_configure() { :; }
src_compile() { :; }

src_install() {
	# Install everything under themes (both dirs and .emerald packs)
	insinto /usr/share/emerald/themes
	# Some repos have mixed case / spaces; doins handles that fine.
	doins -r themes/* || die "Failed to install themes from themes/"

	# In case there are loose .emerald files at repo root (some forks do this)
	if compgen -G "*.emerald" >/dev/null; then
		doins *.emerald || die "Failed to install top-level .emerald files"
	fi

	einstalldocs
}