# Copyright 2004-2010 Sabayon Linux
# Distributed under the terms of the GNU General Public License v2

ETYPE="sources"
K_SABKERNEL_SELF_TARBALL_NAME="sabayon"
K_KERNEL_SOURCES_PKG="sys-kernel/linux-server-sources-${PVR}"
inherit sabayon-kernel
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Official Sabayon Linux Server kernel image"
RESTRICT="mirror"