# http://thawedoutnow.blogspot.jp/2014/10/softether-vpn-on-gentoo.html
EAPI=5

inherit eutils

DESCRIPTION="SoftEther VPN"

HOMEPAGE="https://softether.org/"

VER_BETA="-beta"
VER_DATE="2016.04.24"
REV=`echo ${PR} | /bin/sed -e s/r//g`
SRC_URI="http://www.softether-download.com/files/softether/v${PV}-${REV}${VER_BETA}-${VER_DATE}-tree/Source_Code/softether-src-v${PV}-${REV}${VER_BETA}.tar.gz"
LICENSE="GPL2"

SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+cmd +server -bridge -client"
DEPEND=""
RDEPEND="${DEPEND} sys-apps/ethtool"

S=${WORKDIR}/v${PV}-${REV}

src_prepare() {
	EPATCH_OPTS="-l" epatch ${FILESDIR}/Unix.c-no-threads-max.patch
	epatch ${FILESDIR}/Unix.c-pid-file-path.patch
	epatch ${FILESDIR}/Server.c-activate-all-feature.patch
	epatch ${FILESDIR}/Cedar.c-log-file-path.patch
}

src_configure() {
        cp ${FILESDIR}/Makefile Makefile
}


src_install() {
	# see files/Unix.c-no-threads-max.patch
	export DISABLE_LINUX_THREADS_MAX_SETTING=1
	dst=opt
	for target in server client cmd bridge; do
		Target=`echo $target | /bin/tr a-z A-Z`
		if use $target; then
			mkdir -p ${D}usr/bin
			emake INSTALL_VPN${Target}_DIR=${D}${dst}/vpn${target}/ INSTALL_BINDIR=${D}usr/bin/ ${D}usr/bin/vpn${target} || die
			rm -r ${D}usr
		fi
	done
	if use server; then
		newinitd ${FILESDIR}/vpnserver vpnserver || die
		mkdir -p ${D}/etc/softether/backup.vpn_server.config
		touch ${D}/etc/softether/vpn_server.config
		touch ${D}/etc/softether/lang.config
		dosym /etc/softether/vpn_server.config /${dst}/vpnserver/vpn_server.config
		dosym /etc/softether/lang.config /${dst}/vpnserver/lang.config
		dosym /etc/softether/backup.vpn_server.config /${dst}/vpnserver/backup.vpn_server.config
		mkdir -p ${D}/var/log/softether
	fi
	if use cmd; then
		dosym /${dst}/vpncmd/vpncmd /usr/sbin/vpncmd
	fi
}
