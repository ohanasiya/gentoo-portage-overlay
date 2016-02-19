# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools



DESCRIPTION="Robomongo - is a shell-centric cross-platform open source MongoDB management tool."
HOMEPAGE="https://robomongo.org/"
SRC_URI="https://github.com/paralect/robomongo/archive/v0.8.5.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"


# Prosessable extensions
IUSE=""

DEPEND="=dev-qt/qtwidgets-5* =dev-qt/qtprintsupport-5* >=dev-util/cmake-3.0.2 >=dev-util/scons-2.3.4"

RDEPEND="${DEPEND}"






src_unpack()
{
  cd "${WORKDIR}"
  tar xf ${DISTDIR}/${A} || die
}


src_prepare()
{
  sed -i -e "s/QCleanlooksStyle/QProxyStyle/g" src/robomongo/gui/AppStyle.h
}


src_configure()
{
  mkdir target
  pushd target
    cmake -DCMAKE_BUILD_TYPE=Release .. || die
  popd
}


src_compile()
{
  pushd target
    make || die
  popd
}


src_install()
{
  mkdir -p ${D}/usr/bin
  mkdir -p ${D}/opt
  pushd target
    make install || die
    mv install/share                      ${D}/usr/
    mv install                            ${D}/opt/robomongo
    ln -s /opt/robomongo/bin/robomongo.sh ${D}/usr/bin/robomongo
  popd
}
