EAPI=8

inherit git-r3

DESCRIPTION="Sound Open Firmware binary firmware and topology files"
HOMEPAGE="https://github.com/thesofproject/sof-bin"
EGIT_REPO_URI="https://github.com/thesofproject/sof-bin.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
RESTRICT="strip"

src_install() {
	insinto /lib/firmware/intel

	# Install the upstream release-style firmware trees when present.
	for d in sof sof-tplg sof-ipc4 sof-ipc4-tplg sof-ipc4-lib sof-ace-tplg; do
		if [[ -d "${S}/${d}" ]]; then
			doins -r "${S}/${d}"
		fi
	done

	# Git checkout layout: install newest IPC3 RPL/HDA files your current kernel asks for.
	insinto /lib/firmware/intel/sof
	if [[ -f "${S}/v2.2.x/sof-v2.2/sof-rpl-s.ri" ]]; then
		newins "${S}/v2.2.x/sof-v2.2/sof-rpl-s.ri" sof-rpl-s.ri
	fi

	insinto /lib/firmware/intel/sof-tplg
	if [[ -f "${S}/v2.2.x/sof-tplg-v2.2.1/sof-hda-generic.tplg" ]]; then
		newins "${S}/v2.2.x/sof-tplg-v2.2.1/sof-hda-generic.tplg" sof-hda-generic.tplg
	fi

	dodoc README.md README.Intel LICENCE.Intel
}
