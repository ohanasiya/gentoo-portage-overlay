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
KEYWORDS=""
IUSE=""



# =dev-python/python-distutils-extra-2*
# =dev-python/pygobject-2*
RDEPEND="${DEPEND}
    x11-themes/gtk-engines-unico
    dev-python/setuptools
    dev-python/pyxdg
    dev-python/pygtk"



#src_unpack()
#{
#	mkdir -p ${S}
#	cd       ${S}
#	unpack   ${A}
#}

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

#post_install()
#{
#	gtk-update-icon-cache -q /usr/share/icons/hicolor/
#	xdg-icon-resource forceupdate
#	xdg-desktop-menu forceupdate
#}
#post_update()
#{
#	post_install
#}
#post_remove()
#{
#	post_install
#}


#src_unpack()
#{
#  cd "${WORKDIR}"
#   ${DISTDIR}/${P}-1.any.pkg.tar.xz || die
#}

#src_compile()
#{
#	python2 setup.py build || die
#}

#src_install()
#{
#	python2 setup.py install --root ${D} || die
#}

