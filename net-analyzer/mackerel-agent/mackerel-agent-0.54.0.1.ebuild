# Copyright 2018 NoNameA 774
# Distributed under the terms of the MIT License
# $Id$

EAPI=6

DESCRIPTION="mackerel agent"
SLOT="0"
KEYWORDS="amd64"
SRC_URI="https://github.com/mackerelio/mackerel-agent/releases/download/v0.54.0/mackerel-agent_linux_amd64.tar.gz"

IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/mackerel-agent_linux_amd64"


src_install() {
  dobin mackerel-agent

  insinto /etc/mackerel-agent
  doins mackerel-agent.conf

  keepdir /var/lib/mackerel-agent
}
