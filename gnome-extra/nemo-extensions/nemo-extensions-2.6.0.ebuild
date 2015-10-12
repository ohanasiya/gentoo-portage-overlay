# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools



DESCRIPTION="extensions for cinnamon's file-manager nemo"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/2.6.x.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"


# Prosessable extensions
IUSE="fileroller dropbox gtkhash preview python rabbitvcs repairer seahorse share"
MODULES=${IUSE//-/}

DEPEND="( =gnome-extra/nemo-2.6* )
    fileroller? ( app-arch/file-roller )
    python? ( dev-lang/python dev-python/pygobject )
    rabbitvcs? ( dev-vcs/rabbitvcs >=gnome-extra/nemo-1.1.2 >=dev-python/dbus-python-1.2.0 )"
#    rabbitvcs? ( dev-vcs/rabbitvcs dev-vcs/git dev-vcs/subversion dev-vcs/cvs dev-util/meld dev-python/pygtk dev-python/pygobject dev-python/pysvn dev-python/configobj dev-python/simplejson dev-python/dulwich dev-python/dbus-python )"

RDEPEND="${DEPEND}"

REQUIRED_USE="rabbitvcs? ( python )"






INSTALL_MODULE_LIST="rabbitvcs"
install_module_rabbitvcs()
{
  local vbd=${D}/usr/share/nemo-python/extensions
  local vbf=RabbitVCS.py
  local vsd=${D}/usr/bin
  local vsf=nemo-extensions.sh
  mkdir -p  ${vbd}
  mkdir -p  ${vsd}
  cp ${vbf} ${vbd}/
  chmod a+r ${vbd}/${vbf}
  echo "nemo -q ; sleep 1 ; pgrep -f service.py | xargs kill 2>&1 >/dev/null ; nohup nemo 2>&1 >/dev/null &" > ${vsd}/${vsf}
  chmod 751                                                                                                    ${vsd}/${vsf}
  einfo "!!!!!!!!!!!!!!!!!!!!!"
  einfo "!!!!! ATTENTION !!!!!"
  einfo "You must type ${vsf} at first if you want to use nemo with RabbitVCS extension."
}





src_unpack()
{
  cd "${WORKDIR}"
  unpack ${A}
  mv ${PN}-2.6.x ${P}
}

src_prepare()
{
  local s=
  for module in ${MODULES}; do
    if use ${module}; then
      elog "Preparing ${module}"
      pushd nemo-${module}
      if [ -n "`ls *.sh`" ]; then
        eautoreconf
      fi
      popd
    fi
  done
}

src_configure()
{
  for module in ${MODULES}; do
    if use ${module}; then
      elog "Configuring ${module}"
      pushd nemo-${module}
      if [ -n "`ls *.sh`" ]; then
        econf
      fi
      popd
    fi
  done
}

src_compile()
{
  for module in ${MODULES}; do
    if use ${module}; then
      elog "Compiling ${module}"
      pushd nemo-${module}
      if [ -n "`ls *.sh`" ]; then
        emake
      fi
      popd
    fi
  done
}

src_install()
{
  for module in ${MODULES}; do
    if use ${module}; then
      elog "Installing ${module}"
      pushd nemo-${module}
      if [ -n "`ls *.sh`" ]; then
        emake DESTDIR="${D}" install
        elog "Removing .a and .la files"
        find ${D} -name "*.a" -exec rm {} + -o -name "*.la" -exec rm {} + || die
        dodoc README
      elif [ -n "`echo "${INSTALL_MODULE_LIST}" | grep ${module}`" ]; then
        install_module_${module} || die
      fi
      popd
    fi
  done
}
