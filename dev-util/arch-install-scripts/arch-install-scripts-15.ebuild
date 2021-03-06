# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Arch Linux install tools (pacstrap, genfstab, arch-chroot)"
HOMEPAGE="https://projects.archlinux.org/arch-install-scripts.git/"
SRC_URI="https://projects.archlinux.org/${PN}.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/pacman"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
