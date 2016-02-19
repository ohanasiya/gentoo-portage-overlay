# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils

DESCRIPTION="gWakeOnLan - Wake up your machines using Wake on LAN"
HOMEPAGE="http://www.muflone.com/gwakeonlan/"
SRC_URI="https://github.com/muflone/gwakeonlan/releases/download/${PV}/gwakeonlan-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="${DEPEND}
		 dev-python/pygtk
		 x11-themes/gtk-engines-murrine"


src_install()
{
    python2 setup.py install --root ${D}
}
pkg_postinst()
{
    return
}
pkg_postrm()
{
    return
}
