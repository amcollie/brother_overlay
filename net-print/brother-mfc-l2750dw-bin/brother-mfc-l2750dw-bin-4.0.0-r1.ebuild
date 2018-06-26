# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils rpm linux-info multilib

DESCRIPTION="Brother MFC-L2750DW Laser printer driver"

HOMEPAGE="http://support.brother.com"

SRC_URI="http://download.brother.com/welcome/dlf103529/mfcl2750dwpdrv-4.0.0-1.i386.rpm"

LICENSE="brother-eula GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE="avahi"

RESTRICT="mirror strip"

DEPEND="net-print/cups
	avahi? ( net-dns/avahi
		sys-auth/nss-mdns )
		app-text/a2ps"
RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK=""
	if use amd64; then
		CONFIG_CHECK="${CONFIG_CHECK} ~IA32_EMULATION"
		if ! has_multilib_profile; then
			die "This package CANNOT be installed on pure 64-bit system. \
				You need multilib enabled."
		fi
	fi

	linux-info_pkg_setup
}

src_install() {
	cp -r var "${ED%/}"
	cp -r opt "${ED%/}"
	cp -r etc "${ED%/}"
	
	if use amd64; then
		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/lpd/x86_64/rawtobr3" \
			opt/brother/Printers/MFCL2750DW/lpd/rawtobr3
		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/lpd/x86_64/brprintconflsr3" \
			/opt/brother/Printers/MFCL2750DW/lpd/brprintconflsr3
	else
		dosym "${ED%/}/opt/brother/Printer/MFCL2750DW/lpd/i686/rawtobr3" \
			/opt/brother/Printers/MFCL2750DW/lpd/rawobr3
		dosym "${ED%/}/opt/brother/Printer/MFCL2750DW/lpd/i686/brprintconflsr3" \
			/opt/brother/Printers/MFCL2750DW/lpd/brprintconflsr3
	fi
	
	dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/inf/brMFCL2750DWrc" \
		/etc/opt/brother/Printers/MFCL2750DW/inf/brprintconflsr3
	
	if [ ! -e /usr/bin/brprintconflsr3_MFCL2750DW ];then
		(echo "#! /bin/sh"  > /usr/bin/brprintconflsr3_MFCL2750DW)
		(echo "/opt/brother/Printers/MFCL2750DW/lpd/brprintconflsr3 -P MFCL2750DW" '$''*' \
			>> /usr/bin/brprintconflsr3_MFCL2750DW)
		(chmod 755 /usr/bin/brprintconflsr3_MFCL2750DW)
	fi
	
	if [ -e /usr/lib/cups/filter ] && [ ! -e /usr/lib/cups/filter/lpdwrapper ];then 
  		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/lpdwrapper" \
  			/usr/lib/cups/filter/brother_lpdwrapper_MFCL2750DW
	fi
	if [ -e /usr/lib32/cups/filter ] && [ ! -e /usr/lib32/cups/filter/lpdwrapper ];then 
  		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/lpdwrapper" \
  			/usr/lib32/cups/filter/brother_lpdwrapper_MFCL2750DW
	fi
	if [ -e /usr/lib64/cups/filter ] && [ ! -e /usr/lib64/cups/filter/lpdwrapper ];then 
  		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/lpdwrapper" \
  			/usr/lib64/cups/filter/brother_lpdwrapper_MFCL2750DW
	fi
	if [ -e /usr/libexec/cups/filter ] && [ ! -e /usr/libexec/cups/filter/lpdwrapper ];then 
		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/lpdwrapper" \
			/usr/libexec/cups/filter/brother_lpdwrapper_MFCL2750DW
	fi
	if [ -e /usr/share/cups/model ];then
  		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/brother-MFCL2750DW-cups-en.ppd" \
  			/usr/share/cups/model/brother-MFCL2750DW-cups-en.ppd
  		PPDDIR=/usr/share/cups/model/
	fi	
	if [ -e /usr/share/ppd ];then
		if [ ! -e /usr/share/ppd/brother ];then
			mkdir /usr/share/ppd/brother
		fi
		dosym "${ED%/}/opt/brother/Printers/MFCL2750DW/cupswrapper/brother-MFCL2750DW-cups-en.ppd" \
			/usr/share/ppd/brother/brother-MFCL2750DW-cups-en.ppd
		PPDDIR=/usr/share/ppd/brother/
	fi
}

pkg_postinst() {
	
	
	einfo "If you don't use avahi with nss-mdns, you'll have to use a static \
		IP address in your printer configuration"
	einfo "If you want to use a broadcasted name, add .local to it"
	einfo "You can test if it's working with ping printername.local"
}