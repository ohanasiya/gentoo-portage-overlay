# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit autotools python readme.gentoo


NEMO_VER="2.8"
DESCRIPTION="Extensions for Cinnamon's file-manager nemo"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${NEMO_VER}.x.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"


# Prosessable extensions
IUSE="dropbox fileroller gtkhash preview python rabbitvcs repairer seahorse share"
MODULES=${IUSE//-/}

DEPEND="=gnome-extra/nemo-${NEMO_VER}*
    fileroller? ( app-arch/file-roller )
    python? ( =dev-lang/python-2.7* =dev-python/pygobject-2* )
    rabbitvcs? ( dev-vcs/rabbitvcs[-caja,-nautilus,-thunar] >=dev-python/dbus-python-0.8 )"
### rabbitvcs? ( dev-vcs/rabbitvcs dev-vcs/git dev-vcs/subversion dev-vcs/cvs dev-util/meld dev-python/pygtk dev-python/pygobject dev-python/pysvn dev-python/configobj dev-python/simplejson dev-python/dulwich dev-python/dbus-python )

RDEPEND="${DEPEND}"

REQUIRED_USE="rabbitvcs? ( python )"






INSTALL_MODULE_LIST="rabbitvcs"
install_module_rabbitvcs()
{
	local vbd=${D}/usr/share/nemo-python/extensions
	local vbf=RabbitVCS.py
	local vsd=${D}/usr/bin
	local vsf=nemo-extensions-rabbitvcs.sh
	local vst="eselect python set python2.7 ; nemo -q ; sleep 1 ; pgrep -f service.py | xargs kill 2>&1 >/dev/null"
	mkdir -p  ${vbd}
	cp ${vbf} ${vbd}/
	chmod a+r ${vbd}/${vbf}
	mkdir -p  ${vsd}
	echo "#!/bin/sh
        sudo $vst
        nemo 2>/dev/null 1>/dev/null &" > ${vsd}/${vsf}
	chmod a+x                               ${vsd}/${vsf}
	elog "You must type $vsf to use rabbitvcs on nemo at first."
}










pkg_setup()
{
	python_set_active_version 2
}

pkg_postinst()
{
	return
}



src_unpack()
{
	cd "${WORKDIR}"
	unpack ${A}
	mv ${PN}-${NEMO_VER}.x ${P}
}

src_prepare()
{
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
				if [ "${module}" = "python" ]; then
					ewarn "Python scripts of nemo-extensions works on python2.7 correctly."
				fi
			elif [ -n "`echo "${INSTALL_MODULE_LIST}" | grep ${module}`" ]; then
				install_module_${module} || die "fail to install module ${module}"
			fi
			popd
		fi
	done
}

