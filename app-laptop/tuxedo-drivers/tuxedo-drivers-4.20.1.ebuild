# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

DESCRIPTION="Kernel modules for TUXEDO laptops (includes Uniwill/Clevo support)"
HOMEPAGE="https://github.com/tuxedocomputers/tuxedo-drivers"
SRC_URI="https://deb.tuxedocomputers.com/ubuntu/pool/main/t/tuxedo-drivers/tuxedo-drivers_${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
#PATCHES=(
#	"${FILESDIR}/eluktronics-mech17.patch"
#)
IUSE=""

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

# IMPORTANT:
# Do NOT set S here; the Debian-style tarball directory name can vary.
# We'll auto-detect it in src_unpack().

pkg_setup() {
	local CONFIG_CHECK="
		ACPI
		ACPI_WMI
		ACPI_EC
		INPUT_SPARSEKMAP
		LEDS_CLASS
		LEDS_CLASS_MULTICOLOR
	"

	local ERROR_ACPI="CONFIG_ACPI is required"
	local ERROR_ACPI_WMI="CONFIG_ACPI_WMI is required"
	local ERROR_ACPI_EC="CONFIG_ACPI_EC is required"
	local ERROR_INPUT_SPARSEKMAP="CONFIG_INPUT_SPARSEKMAP is required"
	local ERROR_LEDS_CLASS="CONFIG_LEDS_CLASS is required (keyboard backlight)"
	local ERROR_LEDS_CLASS_MULTICOLOR="CONFIG_LEDS_CLASS_MULTICOLOR is required (RGB keyboard backlight)"

	linux-mod-r1_pkg_setup
}

src_unpack() {
	default

	# Auto-detect the extracted source directory.
	# This avoids hardcoding S to a directory name that may not match the tarball.
	local d
	d="$(find "${WORKDIR}" -mindepth 1 -maxdepth 1 -type d \
		-name "${PN}*" ! -name ".*" | sort | head -n1)"

	[[ -n "${d}" && -d "${d}" ]] || die "Could not find extracted source dir in ${WORKDIR}"

	S="${d}"
	einfo "Using source directory: ${S}"
}

src_prepare() {
	default

	local f="${S}/src/tuxedo_keyboard.c"

	# 1) Add the DMI include right after the existing linux header block begins.
	# We insert it after <linux/mutex.h> since that line exists in your file.
	grep -q '^#include <linux/dmi\.h>' "${f}" || \
		sed -i '/^#include <linux\/mutex\.h>/a #include <linux/dmi.h>' "${f}" || die

	# 2) Insert the DMI table right after MODULE_LICENSE("GPL"); (stable anchor in your file)
	if ! grep -q 'eluktronics_mech17_dmi' "${f}"; then
		sed -i '/^MODULE_LICENSE("GPL");/a \
\
/*\
 * Allow running on ELUKTRONICS MECH-17 (Clevo/Uniwill + Prema BIOS).\
 *\
 * Observed DMI:\
 *   sys_vendor   = "ELUKTRONICS"\
 *   product_name = "MECH-17"\
 *   board_name   = "MECH-17 powered by premamod.com"\
 */\
static const struct dmi_system_id eluktronics_mech17_dmi[] __initconst = {\
	{\
		.ident = "ELUKTRONICS MECH-17",\
		.matches = {\
			DMI_MATCH(DMI_SYS_VENDOR, "ELUKTRONICS"),\
			DMI_MATCH(DMI_PRODUCT_NAME, "MECH-17"),\
		},\
	},\
	{\
		.ident = "ELUKTRONICS MECH-17 (Prema board name)",\
		.matches = {\
			DMI_MATCH(DMI_BOARD_NAME, "MECH-17 powered by premamod.com"),\
		},\
	},\
	{ }\
};\
' "${f}" || die
	fi

	# 3) Bypass tuxedo_is_compatible() only for your DMI (this is the part that stops -ENODEV)
	# Replace: if (!tuxedo_is_compatible()) return -ENODEV;
	# With:    if (!tuxedo_is_compatible() && !dmi_check_system(eluktronics_mech17_dmi)) return -ENODEV;
	# (Only if not already patched)
	if grep -q 'if (!tuxedo_is_compatible())' "${f}" && ! grep -q 'eluktronics_mech17_dmi' "${f}" | grep -q 'dmi_check_system'; then
		sed -i 's/if (!tuxedo_is_compatible())/if (!tuxedo_is_compatible() \&\& !dmi_check_system(eluktronics_mech17_dmi))/' "${f}" || die
	fi

	# If the code uses braces/newlines, do a slightly broader replacement:
	if grep -q 'if (!tuxedo_is_compatible())' "${f}"; then
		sed -i 's/if (!tuxedo_is_compatible())/if (!tuxedo_is_compatible() \&\& !dmi_check_system(eluktronics_mech17_dmi))/' "${f}" || die
	fi
}

src_compile() {
	# linux-mod-r1 expects: "<module_name>=<install_subdir>:<KDIR>:<subdir-with-Makefile>"
	# If upstream rearranges paths, inspect the unpacked tree under:
	#   /var/tmp/portage/${CATEGORY}/${PF}/work/
	local modlist=(
		"clevo_acpi=tuxedo:${KV_OUT_DIR}:src"
		"clevo_wmi=tuxedo:${KV_OUT_DIR}:src"
		"tuxedo_keyboard=tuxedo:${KV_OUT_DIR}:src"
		"uniwill_wmi=tuxedo:${KV_OUT_DIR}:src"

		"ite_8291=tuxedo:${KV_OUT_DIR}:src/ite_8291"
		"ite_8291_lb=tuxedo:${KV_OUT_DIR}:src/ite_8291_lb"
		"ite_8297=tuxedo:${KV_OUT_DIR}:src/ite_8297"
		"ite_829x=tuxedo:${KV_OUT_DIR}:src/ite_829x"

		"tuxedo_compatibility_check=tuxedo:${KV_OUT_DIR}:src/tuxedo_compatibility_check"
		"tuxedo_io=tuxedo:${KV_OUT_DIR}:src/tuxedo_io"

		"tuxedo_nb02_nvidia_power_ctrl=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb02_nvidia_power_ctrl"

		"tuxedo_nb05_keyboard=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"
		"tuxedo_nb05_kbd_backlight=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"
		"tuxedo_nb05_power_profiles=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"
		"tuxedo_nb05_ec=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"
		"tuxedo_nb05_sensors=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"
		"tuxedo_nb05_fan_control=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb05"

		"tuxedo_nb04_keyboard=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"
		"tuxedo_nb04_wmi_ab=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"
		"tuxedo_nb04_wmi_bs=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"
		"tuxedo_nb04_sensors=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"
		"tuxedo_nb04_power_profiles=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"
		"tuxedo_nb04_kbd_backlight=tuxedo:${KV_OUT_DIR}:src/tuxedo_nb04"

		"tuxi_acpi=tuxedo:${KV_OUT_DIR}:src/tuxedo_tuxi"
		"tuxedo_tuxi_fan_control=tuxedo:${KV_OUT_DIR}:src/tuxedo_tuxi"

		"stk8321=tuxedo:${KV_OUT_DIR}:src/stk8321"
		"gxtp7380=tuxedo:${KV_OUT_DIR}:src/gxtp7380"
	)

	local modargs=( "M=${S}" )
	linux-mod-r1_src_compile
}

src_install() {
	# udev rules / hwdb / modprobe snippets shipped by tuxedo-drivers tarball
	if [[ -d "${S}/usr/lib/udev/hwdb.d" ]] ; then
		insinto /usr/lib/udev/hwdb.d
		doins "${S}"/usr/lib/udev/hwdb.d/*.hwdb
	fi

	if [[ -d "${S}/usr/lib/udev/rules.d" ]] ; then
		udev_dorules "${S}"/usr/lib/udev/rules.d/*.rules
	fi

	if [[ -d "${S}/usr/lib/modprobe.d" ]] ; then
		insinto /usr/lib/modprobe.d
		doins "${S}"/usr/lib/modprobe.d/*.conf
	fi

	linux-mod-r1_src_install
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst

	udev_reload
	if command -v udevadm >/dev/null 2>&1 ; then
		udevadm hwdb --update >/dev/null 2>&1 || true
		udevadm control --reload-rules >/dev/null 2>&1 || true
		udevadm trigger >/dev/null 2>&1 || true
	fi

	elog ""
	elog "==================== tuxedo-drivers ===================="
	elog ""
	elog "To load the TUXEDO/Uniwill modules automatically on boot,"
	elog "create:"
	elog ""
	elog "  /etc/modules-load.d/tuxedo.conf"
	elog ""
	elog "with (recommended baseline):"
	elog ""
	elog "  tuxedo_io"
	elog "  uniwill_wmi"
	elog "  tuxedo_keyboard"
	elog ""
	elog "Load immediately (no reboot) with:"
	elog ""
	elog "  modprobe tuxedo_io"
	elog "  modprobe uniwill_wmi"
	elog "  modprobe tuxedo_keyboard"
	elog ""
	elog "Verify:"
	elog "  lsmod | egrep 'tuxedo|uniwill'"
	elog ""
	elog "If Secure Boot is enabled, these modules must be signed"
	elog "(or Secure Boot disabled) or they may fail to load."
	elog ""
	elog "========================================================"
	elog ""
}

pkg_postrm() {
	udev_reload
}