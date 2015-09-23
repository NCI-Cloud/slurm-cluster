#!/bin/bash
#Copyright (c) 2015, National Computational Infrastructure, The Australian National University
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#The views and conclusions contained in the software and documentation are those
#of the authors and should not be interpreted as representing official policies,
#either expressed or implied, of the FreeBSD Project.

SLURM_WGET="http://www.schedmd.com/download/latest/slurm-15.08.0.tar.bz2"
OPENMPI_WGET="http://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.0.tar.gz"
NFS_PART="nothing"

function install_packages {
	yum install -y yum install -y  rdma-6.7_3.15-5.el6.noarch fontconfig-devel-2.8.0-5.el6.x86_64 basesystem-10.0-4.el6.noarch libmlx4-1.0.6-7.el6.x86_64 libXmu-1.1.1-2.el6.x86_64 kernel-2.6.32-504.1.3.el6.x86_64 R-core-3.2.1-2.el6.x86_64 libXrender-devel-0.9.8-2.1.el6.x86_64 libattr-2.4.44-7.el6.x86_64 R-java-3.2.1-2.el6.x86_64 gnupg2-2.0.14-8.el6.x86_64 ConsoleKit-libs-0.4.1-3.el6.x86_64  nfs-utils-lib-1.1.5-11.el6.x86_64 logrotate-3.7.8-23.el6.x86_64 netpbm-10.47.05-11.el6.x86_64 rsync-3.0.6-12.el6.x86_64 sqlite-3.6.20-1.el6_7.2.i686 urw-fonts-2.4-10.el6.noarch keyutils-libs-1.4-5.el6.i686  python-configobj-4.6.0-3.el6.noarch systemtap-2.7-2.el6.x86_64  python-setuptools-0.6.10-3.el6.noarch bzip2-1.0.5-7.el6_0.x86_64 R-3.2.1-2.el6.x86_64  python-prettytable-0.7.2-1.el6.centos.noarch openssh-server-5.3p1-112.el6_7.x86_64  python-jsonpatch-1.2-2.el6.centos.noarch b43-openfwwf-5.2-10.el6.noarch jline-0.9.94-0.8.el6.noarch setools-libs-python-3.3.7-4.el6.x86_64 tcp_wrappers-libs-7.6-57.el6.x86_64 iptables-ipv6-1.4.7-16.el6.x86_64 pth-2.0.7-9.3.el6.x86_64 python-libs-2.6.6-64.el6.i686 puppetlabs-release-6-11.noarch ghc-bytestring-0.9.1.10-46.el6.x86_64 libnih-1.0.1-7.el6.x86_64 ghc-old-locale-1.0.0.2-46.el6.x86_64 ghc-unix-2.4.2.0-46.el6.x86_64 ghc-directory-1.1.0.0-46.el6.x86_64 tcl-8.5.7-6.el6.x86_64 ghc-blaze-builder-0.3.1.0-3.el6.x86_64 libnl-1.1.4-2.el6.x86_64 diffutils-2.8.1-28.el6.x86_64 ghc-json-0.4.4-4.1.el6.x86_64 kmod-kernel-mft-mlnx-3.7.1-3.rhel6u6.x86_64 which-2.19-6.el6.x86_64 ghc-zlib-0.5.3.1-8.el6.x86_64 ofed-scripts-2.3-OFED.2.3.2.0.0.x86_64 ghc-zip-archive-0.1.1.7-6.1.el6.x86_64 cracklib-dicts-2.8.16-4.el6.x86_64  libibumad-1.3.9.MLNX20140817.485ffa6-0.1.x86_64 ghc-base64-bytestring-0.1.1.3-1.el6.x86_64 tzdata-java-2015f-1.el6.noarch centos-release-6-7.el6.centos.12.3.x86_64 mingetty-1.08-5.el6.x86_64 glibc-2.12-1.166.el6_7.1.x86_64 system-config-firewall-tui-1.2.27-7.2.el6_6.noarch libstdc++-4.4.7-16.el6.x86_64 dracut-modules-growroot-0.20-2.el6.noarch db4-4.7.25-19.el6_6.x86_64 keyutils-1.4-5.el6.x86_64 freetype-2.3.11-15.el6_6.1.x86_64 libaio-0.3.107-10.el6.x86_64 elfutils-libs-0.161-3.el6.x86_64 automake-1.11.1-4.el6.noarch libffi-3.0.5-3.2.el6.x86_64 binutils-2.20.51.0.2-5.43.el6.x86_64 pygpgme-0.1-18.20090824bzr68.el6.x86_64 nss-3.19.1-3.el6_6.x86_64 libproxy-0.3.0-10.el6.x86_64 python-iniparse-0.3.1-2.1.el6.noarch pcre-7.8-7.el6.x86_64 libXfixes-5.0.1-2.1.el6.x86_64 vim-minimal-7.4.629-5.el6.x86_64 libXrandr-1.4.1-2.1.el6.x86_64 yum-metadata-parser-1.1.2-16.el6.x86_64 perl-Module-Pluggable-3.90-141.el6.x86_64 perl-5.10.1-141.el6.x86_64 patch-2.6-6.el6.x86_64 perl-IO-Compress-Base-2.021-141.el6.x86_64 apr-util-1.3.9-3.el6_0.1.x86_64 cairo-1.8.8-6.el6_6.x86_64 libXtst-1.2.2-2.1.el6.x86_64 plymouth-0.8.3-27.el6.centos.1.x86_64 libxml2-2.7.6-20.el6.x86_64 poppler-utils-0.12.4-4.el6_6.1.x86_64 pakchois-0.4-3.2.el6.x86_64 perl-IO-Compress-Zlib-2.021-141.el6.x86_64 pixman-0.32.4-4.el6.x86_64 python-requests-2.6.0-3.el6.noarch ppl-0.10.2-11.el6.x86_64 pcre-devel-7.8-7.el6.x86_64 libRmath-devel-3.2.1-2.el6.x86_64 pango-1.28.1-10.el6.x86_64 libcurl-7.19.7-46.el6.x86_64 mailcap-2.1.31-2.el6.noarch openldap-2.4.40-5.el6.x86_64 libcom_err-devel-1.41.12-22.el6.x86_64 perl-libwww-perl-5.833-2.el6.noarch gpg-pubkey-c105b9de-4e0fd3a3 kernel-devel-2.6.32-573.3.1.el6.x86_64 glibc-headers-2.12-1.166.el6_7.1.x86_64 gcc-gfortran-4.4.7-16.el6.x86_64 audit-libs-2.3.7-5.el6.x86_64 ORBit2-2.14.17-5.el6.x86_64 patchutils-0.3.1-3.1.el6.x86_64 coreutils-8.4-37.el6.x86_64 kernel-firmware-2.6.32-573.3.1.el6.noarch swig-1.3.40-6.el6.x86_64 libblkid-2.17.2-12.18.el6.x86_64 yum-3.2.29-69.el6.centos.noarch byacc-1.9.20070509-7.el6.x86_64 libselinux-utils-2.0.94-5.8.el6.x86_64 libxml2-python-2.7.6-20.el6.x86_64 libsepol-devel-2.0.41-4.el6.x86_64 xz-4.999.9-0.5.beta.20091007git.el6.x86_64 grub-0.97-94.el6.x86_64 freetype-devel-2.3.11-15.el6_6.1.x86_64 nano-2.0.9-7.el6.x86_64 ncurses-devel-5.7-4.20090207.el6.x86_64  nss-softokn-freebl-3.14.3-22.el6_6.i686 shadow-utils-4.1.4.2-19.el6_6.1.x86_64 tcl-devel-8.5.7-6.el6.x86_64 shared-mime-info-0.70-6.el6.x86_64 readline-6.0-4.el6.i686 blas-3.2.1-4.el6.x86_64 policycoreutils-2.0.83-24.el6.x86_64 lcms-libs-1.19-1.el6.x86_64 initscripts-9.03.49-1.el6.centos.x86_64 lapack-3.2.1-4.el6.x86_64 file-libs-5.04-21.el6.x86_64 libibverbs-1.1.8-4.el6.x86_64 filesystem-2.4.30-3.el6.x86_64 libsndfile-1.0.20-5.el6.x86_64 librdmacm-1.0.19.1-1.el6.x86_64 R-core-devel-3.2.1-2.el6.x86_64 libasyncns-0.8-1.1.el6.x86_64 libcgroup-0.40.rc1-16.el6.x86_64 info-4.13a-8.el6.x86_64 polkit-0.96-11.el6.x86_64 libacl-2.2.49-6.el6.x86_64 xz-lzma-compat-4.999.9-0.5.beta.20091007git.el6.x86_64 nfs-utils-1.2.3-64.el6.x86_64 bzip2-libs-1.0.5-7.el6_0.x86_64 audit-2.3.7-5.el6.x86_64 xz-devel-4.999.9-0.5.beta.20091007git.el6.x86_64 rsyslog-5.8.10-10.el6_6.x86_64 sed-4.2.1-10.el6.x86_64 epel-release-6-8.noarch db4-4.7.25-19.el6_6.i686 readline-6.0-4.el6.x86_64 psutils-1.17-34.el6.x86_64 krb5-libs-1.10.3-42.el6.i686 audit-libs-python-2.3.7-5.el6.x86_64 java-1.7.0-openjdk-1.7.0.85-2.6.1.3.el6_7.x86_64 findutils-4.4.2-6.el6.x86_64 python-pygments-1.1.1-1.el6.noarch  kernel-2.6.32-573.3.1.el6.x86_64  libmlx5-1.0.2-1.el6.x86_64 cyrus-sasl-2.1.23-15.el6_6.2.x86_64 sudo-1.8.6p3-20.el6_7.x86_64 expat-2.0.1-11.el6_2.x86_64 libyaml-0.1.6-1.el6.x86_64 p11-kit-trust-0.18.5-2.el6_5.2.x86_64 ghc-base-4.3.1.0-46.el6.x86_64 libusb-0.1.12-23.el6.x86_64 ghc-transformers-0.2.2.0-14.el6.x86_64 fontconfig-2.8.0-5.el6.x86_64 ghc-text-0.11.1.5-3.el6.x86_64 ghc-filepath-1.2.0.0-46.el6.x86_64 tk-8.5.7-5.el6.x86_64 ghc-xml-1.3.12-3.el6.x86_64 mlnx-ofa_kernel-2.3-OFED.2.3.2.0.0.1.g7e4238c.rhel6u6.x86_64 ghc-blaze-html-0.4.3.4-1.el6.x86_64 m4-1.4.13-5.el6.x86_64 kmod-iser-1.4.5-OFED.2.3.135.g7e4238c.rhel6u6.x86_64 ghc-binary-0.5.0.2-10.el6.x86_64 groff-1.18.1.4-21.el6.x86_64 ghc-highlighting-kate-0.5.1-1.1.el6.x86_64 cracklib-2.8.16-4.el6.x86_64 ghc-random-1.0.0.3-46.el6.x86_64 libibmad-1.3.11.MLNX20140817.fad53c6-0.1.x86_64 ghc-tagsoup-0.12.6-3.el6.x86_64 libgcc-4.4.7-16.el6.x86_64 kernel-headers-2.6.32-573.3.1.el6.x86_64 python-rsa-3.1.1-5.el6.noarch glibc-common-2.12-1.166.el6_7.1.x86_64 chkconfig-1.3.49.3-5.el6.x86_64 libgssglue-0.1-11.el6.x86_64 nspr-4.10.8-1.el6_6.x86_64 gpgme-1.1.8-3.el6.x86_64 libevent-1.4.13-4.el6.x86_64 dbus-libs-1.2.24-8.el6_6.x86_64 ustr-1.0.4-9.1.el6.x86_64 dsync+-1.1.1-1el6.x86_64 sqlite-3.6.20-1.el6_7.2.x86_64 perl-Error-0.17015-4.el6.noarch libgomp-4.4.7-16.el6.x86_64 libXext-1.3.2-2.1.el6.x86_64 nss-sysinit-3.19.1-3.el6_6.x86_64 newt-python-0.52.11-3.el6.x86_64 libproxy-bin-0.3.0-10.el6.x86_64 cups-libs-1.4.2-72.el6.x86_64 jpackage-utils-1.7.5-3.14.el6.noarch dbus-glib-0.86-6.el6.x86_64 libXi-1.7.2-2.2.el6.x86_64 perl-Pod-Escapes-1.04-141.el6.x86_64 plymouth-core-libs-0.8.3-27.el6.centos.1.x86_64 zip-3.0-1.el6.x86_64 perl-libs-5.10.1-141.el6.x86_64 apr-1.3.9-5.el6_2.x86_64 python-six-1.9.0-2.el6.noarch libX11-1.6.0-6.el6.x86_64 libgfortran-4.4.7-16.el6.x86_64 poppler-0.12.4-4.el6_6.1.x86_64 neon-0.29.3-3.el6_4.x86_64 libX11-devel-1.6.0-6.el6.x86_64 python-chardet-2.2.1-1.el6.noarch cloog-ppl-0.15.7-1.2.el6.x86_64 libicu-devel-4.2.1-12.el6.x86_64 libXcomposite-0.4.3-4.el6.x86_64 libRmath-3.2.1-2.el6.x86_64 passwd-0.77-4.el6_2.2.x86_64 alsa-lib-1.0.22-3.el6.x86_64 db4-utils-4.7.25-19.el6_6.x86_64 rpm-4.8.0-47.el6.x86_64 e2fsprogs-libs-1.41.12-22.el6.x86_64 rootfiles-8.1-6.1.el6.noarch perl-XML-Parser-2.36-7.el6.x86_64 xorg-x11-fonts-Type1-7.2-11.el6.noarch yum-plugin-fastestmirror-1.1.30-30.el6.noarch gettext-devel-0.17-18.el6.x86_64 tar-1.23-13.el6.x86_64 intltool-0.41.0-1.1.el6.noarch gcc-c++-4.4.7-16.el6.x86_64 libIDL-0.8.13-2.1.el6.x86_64 coreutils-libs-8.4-37.el6.x86_64 flex-2.5.35-9.el6.x86_64 dhcp-common-4.1.1-49.P1.el6.centos.x86_64 libuuid-2.17.2-12.18.el6.x86_64 diffstat-1.51-2.el6.x86_64 e2fsprogs-1.41.12-22.el6.x86_64 perl-Compress-Zlib-2.021-141.el6.x86_64 xz-libs-4.999.9-0.5.beta.20091007git.el6.x86_64 libselinux-devel-2.0.94-5.8.el6.x86_64 python-devel-2.6.6-64.el6.x86_64 bzip2-devel-1.0.5-7.el6_0.x86_64 mysql-libs-5.1.73-5.el6_6.x86_64 gzip-1.3.12-22.el6.x86_64 jdk1.8.0_25-1.8.0_25-fcs.x86_64 pinentry-0.7.6-8.el6.x86_64 libpciaccess-0.13.3-0.1.el6.x86_64  efibootmgr-0.5.4-13.el6.x86_64 libogg-1.1.4-2.1.el6.x86_64 pam-1.1.1-20.el6_7.1.x86_64 glib2-2.28.8-4.el6.x86_64 giflib-4.1.6-3.1.el6.x86_64 ncurses-libs-5.7-4.20090207.el6.i686 util-linux-ng-2.17.2-12.18.el6.x86_64 blas-devel-3.2.1-4.el6.x86_64 libsemanage-2.0.43-5.1.el6.x86_64 libXfont-1.4.5-4.el6_6.x86_64 iputils-20071127-20.el6.x86_64 grubby-7.0.15-7.el6.x86_64 lapack-devel-3.2.1-4.el6.x86_64 file-5.04-21.el6.x86_64 setup-2.8.14-20.el6_4.1.noarch openssh-5.3p1-112.el6_7.x86_64 dracut-kernel-004-388.el6.noarch R-java-devel-3.2.1-2.el6.x86_64 tk-devel-8.5.7-5.el6.x86_64 zlib-1.2.3-29.el6.x86_64 selinux-policy-3.7.19-279.el6_7.4.noarch pciutils-3.1.10-4.el6.x86_64 ConsoleKit-0.4.1-3.el6.x86_64 xdg-utils-1.0.2-17.20091016cvs.el6.noarch systemtap-runtime-2.7-2.el6.x86_64 cronie-anacron-1.4.4-15.el6.x86_64 portreserve-0.0.4-9.el6.x86_64 gpg-pubkey-0608b895-4bd22942 gawk-3.1.7-10.el6.x86_64 expat-2.0.1-11.el6_2.i686 netpbm-progs-10.47.05-11.el6.x86_64 openssl-1.0.1e-42.el6.i686 policycoreutils-python-2.0.83-24.el6.x86_64  python-markdown-2.0.1-3.1.el6.noarch libidn-1.18-2.el6.x86_64 librdmacm-utils-1.0.19.1-1.el6.x86_64  libgpg-error-1.7-4.el6.x86_64 libibverbs-devel-1.1.8-4.el6.x86_64  cpio-2.10-12.el6_5.x86_64 subversion-1.6.11-15.el6_7.x86_64 libuser-0.56.13-8.el6_7.x86_64 PyYAML-3.10-3.1.el6.x86_64 p11-kit-0.18.5-2.el6_5.2.x86_64 libpng-devel-1.2.49-1.el6_2.x86_64 gmp-4.3.1-7.el6_2.2.x86_64 ghc-containers-0.4.0.0-46.el6.x86_64 ghc-deepseq-1.1.0.2-9.el6.x86_64 MAKEDEV-3.24-6.el6.x86_64 ghc-old-time-1.0.0.6-46.el6.x86_64 libXrender-0.9.8-2.1.el6.x86_64 psmisc-22.6-19.el6_5.x86_64 ghc-pretty-1.0.1.2-46.el6.x86_64 bc-1.06.95-1.el6.x86_64 ghc-utf8-string-0.3.7-1.el6.x86_64 kmod-mlnx-ofa_kernel-2.3-OFED.2.3.2.0.0.1.g7e4238c.rhel6u6.x86_64 make-3.81-20.el6.x86_64 ghc-network-2.3.0.5-3.el6.x86_64 kmod-srp-1.3.3-OFED.2.3.135.g7e4238c.rhel6u6.x86_64 ghc-pcre-light-0.4-7.el6.x86_64 ghc-citeproc-hs-0.3.4-5.el6.x86_64 ghc-process-1.0.1.5-46.el6.x86_64 plymouth-scripts-0.8.3-27.el6.centos.1.x86_64 pandoc-1.9.4.1-1.1.el6.x86_64 libX11-common-1.6.0-6.el6.noarch libcap-ng-0.6.4-3.el6_0.1.x86_64 nss-softokn-freebl-3.14.3-22.el6_6.x86_64 bash-4.1.2-33.el6.x86_64 krb5-libs-1.10.3-42.el6.x86_64 libtirpc-0.2.1-10.el6.x86_64 elfutils-libelf-0.161-3.el6.x86_64 fipscheck-1.2.0-7.el6.x86_64 openssl-1.0.1e-42.el6.x86_64 perl-URI-1.40-2.el6.noarch newt-0.52.11-3.el6.x86_64 unzip-6.0-2.el6_6.x86_64 nss-softokn-3.14.3-22.el6_6.x86_64 libjpeg-turbo-1.2.1-3.el6_5.x86_64 python-urlgrabber-3.9.1-9.el6.noarch gnutls-2.8.5-18.el6.x86_64 libpng-1.2.49-1.el6_2.x86_64 gamin-0.1.10-9.el6.x86_64 libicu-4.2.1-12.el6.x86_64 avahi-libs-0.6.25-15.el6.x86_64 gdbm-1.8.0-38.el6.x86_64 perl-version-0.77-141.el6.x86_64 python-libs-2.6.6-64.el6.x86_64 libICE-1.0.6-1.el6.x86_64 libxcb-1.9.1-3.el6.x86_64 java-1.6.0-openjdk-1.6.0.36-1.13.8.1.el6_7.x86_64 libXdamage-1.1.3-4.el6.x86_64 sysvinit-tools-2.87-6.dsf.el6.x86_64 gdk-pixbuf2-2.24.1-5.el6.x86_64 postfix-2.6.6-6.el6_5.x86_64 libxcb-devel-1.9.1-3.el6.x86_64 perl-Git-1.7.1-3.el6_4.1.noarch gdb-7.2-83.el6.x86_64 redhat-rpm-config-9.0.3-44.el6.centos.noarch cvs-1.11.23-16.el6.x86_64 hwdata-0.233-14.1.el6.noarch gettext-libs-0.17-18.el6.x86_64 yum-presto-0.6.2-1.el6.noarch eggdbus-0.6-3.el6.x86_64 man-1.6f-32.el6.x86_64 curl-7.19.7-46.el6.x86_64 libss-1.41.12-22.el6.x86_64 perl-HTML-Tagset-3.20-4.el6.noarch attr-2.4.44-7.el6.x86_64 libstdc++-devel-4.4.7-16.el6.x86_64 hicolor-icon-theme-0.11-1.1.el6.noarch sgml-common-0.6.3-33.el6.noarch kernel-devel-2.6.32-504.3.3.el6.x86_64 gcc-4.4.7-16.el6.x86_64 libselinux-2.0.94-5.8.el6.x86_64 jasper-libs-1.900.1-16.el6_6.3.x86_64 ethtool-3.5-6.el6.x86_64 ctags-5.8-2.el6.x86_64 openssl-devel-1.0.1e-42.el6.x86_64 indent-2.2.10-7.el6.x86_64 python-boto-2.38.0-1.el6.noarch zlib-devel-1.2.3-29.el6.x86_64 environment-modules-3.2.10-2.el6.x86_64 keyutils-libs-devel-1.4-5.el6.x86_64 sqlite-devel-3.6.20-1.el6_7.2.x86_64 wget-1.12-5.el6_6.1.x86_64 less-436-13.el6.x86_64 flac-1.2.1-7.el6_6.x86_64 dmidecode-2.12-6.el6.x86_64 xorg-x11-proto-devel-7.7-9.el6.noarch libselinux-2.0.94-5.8.el6.i686 kpathsea-2007-57.el6_2.x86_64 libcom_err-1.41.12-22.el6.i686 bzip2-libs-1.0.5-7.el6_0.i686 iproute-2.6.32-45.el6.x86_64 xorg-x11-font-utils-7.2-11.el6.x86_64 dracut-004-388.el6.noarch libvorbis-1.2.3-4.el6_2.1.x86_64 openssh-clients-5.3p1-112.el6_7.x86_64 libXau-devel-1.0.6-4.el6.x86_64 cups-1.4.2-72.el6.x86_64 libXft-devel-2.3.1-2.el6.x86_64 R-devel-3.2.1-2.el6.x86_64 libcap-2.16-5.5.el6.x86_64 poppler-data-0.4.0-1.el6.noarch libsemanage-python-2.0.43-5.1.el6.x86_64 popt-1.13-7.el6.x86_64 desktop-file-utils-0.15-9.el6.x86_64 GConf2-2.28.0-6.el6.x86_64 tmpwatch-2.9.16-4.el6.x86_64 systemtap-client-2.7-2.el6.x86_64 libsepol-2.0.41-4.el6.x86_64 cronie-1.4.4-15.el6.x86_64 libselinux-python-2.0.94-5.8.el6.x86_64 gdbm-1.8.0-38.el6.i686 python-oauth-1.0.1-1.el6.centos.noarch ttmkfdir-3.0.9-32.1.el6.x86_64 libffi-3.0.5-3.2.el6.i686 lua-5.1.4-4.1.el6.x86_64 python-backports-ssl_match_hostname-3.4.0.2-4.el6.centos.noarch  selinux-policy-targeted-3.7.19-279.el6_7.4.noarch python-cheetah-2.4.1-1.el6.x86_64 libibverbs-utils-1.1.8-4.el6.x86_64 python-jsonpointer-1.0-3.el6.centos.noarch libdrm-2.4.59-2.el6.x86_64 checkpolicy-2.0.22-1.el6.x86_64 setools-libs-3.3.7-4.el6.x86_64 rhino-1.7-0.7.r2.2.el6.noarch dhclient-4.1.1-49.P1.el6.centos.x86_64 authconfig-6.1.12-23.el6.x86_64 libtasn1-2.3-6.el6_5.x86_64 cloud-init-0.7.5-10.el6.centos.2.x86_64 libgcrypt-1.4.5-11.el6_4.x86_64 ghc-array-0.3.0.2-46.el6.x86_64 upstart-0.6.5-13.el6_5.3.x86_64 ghc-mtl-2.0.1.0-10.el6.x86_64 libutempter-1.1.5-4.1.el6.x86_64 libXau-1.0.6-4.el6.x86_64 ghc-parsec-3.1.1-8.el6.x86_64 net-tools-1.60-110.el6_2.x86_64 libXft-2.3.1-2.el6.x86_64 ghc-syb-0.3.3-4.el6.x86_64 ghc-time-1.2.0.3-46.el6.x86_64 mlnx-ofa_kernel-devel-2.3-OFED.2.3.2.0.0.1.g7e4238c.rhel6u6.x86_64 ghc-pandoc-types-1.9.1-3.el6.x86_64 dash-0.5.5.1-4.el6.x86_64 mlnxofed-docs-2.3-2.0.0.noarch ghc-digest-0.0.1.1-1.el6.x86_64 ghc-HTTP-4000.1.2-4.el6.x86_64 ghc-temporary-1.1.2.3-2.el6.x86_64 redhat-logos-60.0.14-12.el6.centos.noarch mft-3.7.1-3.x86_64 ghc-extensible-exceptions-0.1.1.2-46.el6.x86_64 ncurses-base-5.7-4.20090207.el6.x86_64 libedit-2.11-4.20080712cvs.1.el6.x86_64 system-config-firewall-base-1.2.27-7.2.el6_6.noarch tzdata-2015f-1.el6.noarch ncurses-libs-5.7-4.20090207.el6.x86_64 cloud-utils-growpart-0.27-10.el6.x86_64 libcom_err-1.41.12-22.el6.x86_64 deltarpm-3.5-0.5.20090913git.el6.x86_64 rpcbind-0.2.0-11.el6.x86_64 nss-util-3.19.1-1.el6_6.x86_64 fipscheck-lib-1.2.0-7.el6.x86_64 ca-certificates-2015.2.4-65.0.1.el6_6.noarch slang-2.2.1-1.el6.x86_64 autoconf-2.63-5.1.el6.noarch cyrus-sasl-lib-2.1.23-15.el6_6.2.x86_64 module-init-tools-3.9-25.el6.x86_64 python-pycurl-7.19.0-8.el6.x86_64 libproxy-python-0.3.0-10.el6.x86_64 libssh2-1.4.2-1.el6_6.1.x86_64 pkgconfig-0.23-9.1.el6.x86_64 mpfr-2.4.1-6.el6.x86_64 grep-2.20-3.el6.x86_64 libtiff-3.9.4-10.el6_5.x86_64 procps-3.2.8-33.el6.x86_64 atk-1.30.0-1.el6.x86_64 perl-Pod-Simple-3.13-141.el6.x86_64 kbd-misc-1.15-11.el6.noarch python-2.6.6-64.el6.x86_64 libSM-1.2.1-2.el6.x86_64 perl-Compress-Raw-Zlib-2.021-141.el6.x86_64 pulseaudio-libs-0.9.21-21.el6.x86_64 kbd-1.15-11.el6.x86_64 libXcursor-1.1.14-2.1.el6.x86_64 openjpeg-libs-1.3-11.el6.x86_64 libXinerama-1.1.3-2.1.el6.x86_64 java-1.6.0-openjdk-devel-1.6.0.36-1.13.8.1.el6_7.x86_64 crontabs-1.10-33.el6.noarch git-1.7.1-3.el6_4.1.x86_64 python-urllib3-1.10.2-1.el6.noarch libart_lgpl-2.3.20-5.1.el6.x86_64 python-argparse-1.2.1-2.1.el6.noarch gettext-0.17-18.el6.x86_64 nss-tools-3.19.1-3.el6_6.x86_64 acpid-1.0.10-2.1.el6.x86_64 libthai-0.1.12-3.el6.x86_64 elfutils-0.161-3.el6.x86_64 rpm-libs-4.8.0-47.el6.x86_64 rpm-python-4.8.0-47.el6.x86_64 acl-2.2.49-6.el6.x86_64 perl-HTML-Parser-3.64-2.el6.x86_64 krb5-devel-1.10.3-42.el6.x86_64 gtk2-2.24.23-6.el6.x86_64 cpp-4.4.7-16.el6.x86_64 glibc-devel-2.12-1.166.el6_7.1.x86_64 libtool-2.2.6-15.5.el6.x86_64 systemtap-devel-2.7-2.el6.x86_64 cscope-15.6-6.el6.x86_64 pcsc-lite-libs-1.5.2-15.el6.x86_64 rcs-5.7-37.el6.x86_64 ghostscript-8.70-21.el6.x86_64 doxygen-1.6.1-6.el6.x86_64 rpm-build-4.8.0-47.el6.x86_64 pciutils-libs-3.1.10-4.el6.x86_64 libgcj-4.4.7-16.el6.x86_64 python-backports-1.0-5.el6.x86_64 mstflint-4.0.0-0.1.30.g00eb005.el6.x86_64 ncurses-5.7-4.20090207.el6.x86_64 keyutils-libs-1.4-5.el6.x86_64 libXt-1.1.4-6.1.el6.x86_64 glibc-2.12-1.166.el6_7.1.i686 dbus-1.2.24-8.el6_6.x86_64 zlib-1.2.3-29.el6.i686 libfontenc-1.0.5-2.el6.x86_64 iptables-1.4.7-16.el6.x86_64 ghostscript-fonts-5.50-23.2.el6.noarch udev-147-2.63.el6.x86_64 clustershell strace python-pip libffi-devel numactl numactl-devel hwloc hwloc-devel munge-devel munge perl-CPAN
	if [ $? -ne 0 ]; then
		echo "yum failed... exiting"
	fi
}

function install_openstack_client {
	pip install --upgrade pip
	pip install python-novaclient python-keystoneclient python-cinderclient cryptography
	pip install python-novaclient python-keystoneclient python-cinderclient cryptography --upgrade
	pip install pyopenssl ndg-httpsclient pyasn1 
	pip install pyopenssl ndg-httpsclient pyasn1 --upgrade
}
function create_data_dir {
	mkdir -p /data
}

function check_data_fs {
	ret=`/bin/df | grep /data | wc -l`
	if [ $ret -ne 1 ]; then
		echo "/data is not mounted. Please refer to installation manual"
		exit 1
	else
		echo "/data mounted"
	fi
}
function create_fs_base {
	for i in apps home opt short system; do 
		mkdir -p /data/$i
	done
	mkdir -p /data/opt/etc
}
function download_slurm {
	fname=$(basename $SLURM_WGET)
	if [ -f $fname ]; then
		echo Slurm download found... Will not check for the new version
	else
		ret=$(wget $SLURM_WGET)
	
		if [ $? -ne 0 ]; then
			echo "Could not download Slurm verson ($fname)...Maybe a new version was released"
			echo "Please check http://schedmd.com/#repos and update SLURM_WGET link"
			echo "If you insist, we can download a previous version for you"
			read -p "Download older version? " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				SLURM_WGET="http://schedmd.com/download/archive/$fname"
				#Not implementing a recursive function here.
				ret=$(wget $SLURM_WGET)
				if [ $? -ne 0 ]; then
					echo Older version of slurm download also failed... Maybe the site is down. Giving up
					exit 1
				fi
			fi
		
		fi
	fi
}

function install_slurm {
	if [ -d /opt/slurm ]; then
		echo Slurm found... Using existing at /opt/slurm
		return 1
	fi
	PWD=$(pwd)
	fname=$(basename $SLURM_WGET)
	dirname=$(tar -tf $fname  | head -1)
	tar -xvf $fname
	echo $dirname
	cd $dirname
	adduser slurm
	./configure --prefix /opt/slurm
	make && make install
	if [ $? -ne 0 ]; then
		echo Slurm compilation filed.. Exiting
		exit 1
	fi
	cp etc/init.d.slurm /etc/init.d/slurm
	sed -i '/### END INIT /a exec_prefix="/opt/slurm"' /etc/init.d/slurm 
	sed -i '/### END INIT /a prefix="/opt/slurm"' /etc/init.d/slurm 
	mkdir -p /opt/slurm/etc
	mkdir -p /var/slurm/log/
	cp slurm.conf.template /opt/slurm/etc/slurm.conf
	chmod +x /etc/init.d/slurm
	cat > /etc/profile.d/slurm.sh <<EOF
PATH=\$PATH:/opt/slurm/bin:/opt/slurm/sbin

if [ -z "\$MANPATH" ] ; then
  	MANPATH=/opt/slurm/share/man
else
  	MANPATH=\$MANPATH:/opt/slurm/share/man
fi
export PATH MANPATH
EOF
}

# Not using this. Let user follow the installation manual.
function check_partitions() {
        echo "Select partition you wish to use to export NFS share (e.g vdc or vdb)?"
        echo "It is recommended to use persistant volume (not the ephemeral disk) as an NFS share. Ephemeral disk is usually vdb on NeCTAR"
        echo " "
	echo "On NCI Cloud we highly recommend using Ceph storage which will be /dev/vdc after mounting. If you do not see 'vdc' please refer to installation manual"
	echo "You can still use 'vdb' but remember that you will loose data on termination of this instance"

	PS3="Please choose partition to use as your NFS share:  "
	partitions=$(cat /proc/partitions | grep -v "vda" | grep -v "name" | grep "vd" | awk '{print $4}')

        select opt in $partitions; do
                echo "$opt"
		NFS_PART=$opt
		break
        done
}

# Not using this function. Let user folow the installation manual
function check_mounts {
	echo Checking is $NFS_PART is already mounted...
	Ret=$(cat /proc/mounts | grep "/data" | wc -l)
	if [ $Ret == 1 ]; then
		echo You already have /data mounted. We will use this partition as NFS export. 
	else
		Ret=$(cat /proc/mounts | grep $NFS_PART | wc -l)
		if [ $Ret != 1 ]; then
			echo $NFS_PART is not mounted. Attempting to mount /dev/vdc
			Ret=$(mount -t ext4 /dev/$NFS_PART /data)
			if [ $Ret != 0 ]; then
				echo Cannot mount partition. It might not be formated. please run mkfs.ext4 /dev/$NFS_PART and try again
				exit 1
			fi
		fi
	fi	
}

#additional packages that might be missing in the image. We will build these in the next image version
function house_keeping {
	#We fix a few bugs that are in the image. Not sure why this is here. I am not going to bother spitting error for this
	mv /etc/yum.repos.d/rdo-release.repo /etc/yum.repos.d/rdo-release.repo.disable 2>/dev/null
	pip install pyopenssl ndg-httpsclient pyasn1 
	pip install pyopenssl ndg-httpsclient pyasn1 --upgrade
	mkdir -p /var/slurm/log/
	#Remove ec2-user. I am not going to explain why
	#sed -i 's/^disable_root .*$/disable_root: 0/' /etc/cloud/cloud.cfg
}

function bind_mount {
	umount -l /apps /home /short /system /opt
	mkdir -p /apps
	mkdir -p /short
	mkdir -p /system
 	if grep '/data/system' /etc/fstab
	then
		echo "/etc/fstab entires found..."
	else		
		echo /data/apps /apps none defaults,bind 0 0 >> /etc/fstab
		echo /data/home /home none defaults,bind 0 0 >> /etc/fstab
		echo /data/short /short none defaults,bind 0 0 >> /etc/fstab
		echo /data/system /system none defaults,bind 0 0 >> /etc/fstab
		echo /data/opt /opt  none defaults,bind 0 0 >> /etc/fstab
	fi
	for mount in /apps /home /short /system /opt; do
		if grep -qs "$mount" /proc/mounts; then
 			 echo "$mount is bind mounted."
		else
  			 echo "$mount not mounted... attempting to mount"
  			mount "$mount"
  			if [ $? -eq 0 ]; then
   				echo "Mounted $mount"
  			else
   				echo "Could not mount ($mount)... Exiting"
				exit 1
  			fi
		fi
	done


	mkdir -p /opt/etc
	mkdir -p /short/slurm
	chown slurm:slurm /short/slurm
	
}

function install_openmpi_1.10.0 {
        if [ -d /apps/openmpi/1.10.0 ]; then
                echo OpenMPI-1.10.0 found... Using existing at /apps/openmpi/1.10.0
                return 1
        fi
	Ret=$(wget $OPENMPI_WGET)
        PWD=$(pwd)
        fname=$(basename $OPENMPI_WGET)
        dirname=$(tar -tf $fname  | head -1)
        tar -xvf $fname
        echo $dirname
        cd $dirname
        ./configure --prefix=/apps/openmpi/1.10.0 --enable-shared --enable-builtin-atomics --enable-mpi-thread-multiple --enable-mca-no-build=portals4,portals,elan,usnic --enable-orterun-prefix-by-default
        make && make install
        if [ $? -ne 0 ]; then
                echo OpenMPI-1.10.0 compilation filed.. Exiting
                exit 1
        fi
	
	#Setup OpenMPI Module in /apps/Modules/modulefiles
	mkdir -p /apps/Modules/modulefiles/openmpi/
	cat > /apps/Modules/modulefiles/openmpi/1.10.0 << EOF
#%Module1.0#####################################################################
##
## standalone modulefile
##
proc ModulesHelp { } {
        global ompiver

        puts stderr "\tAdds OpenMPI $ompiver path"
        puts stderr "\n\tVersion $ompiver\n"
}
 
module-whatis    "OpenMPI. You have to know what it is! :)"

# for Tcl script use only
set     ompiver 1.10.0

set             OMPI   			/apps/openmpi/\$ompiver
setenv          OMPI   			\$OMPI
setenv		OPAL_PREFIX		\$OMPI
setenv 		MPI_HOME             	\$OMPI
append-path     PATH    		\$OMPI/bin/
prepend-path    LD_LIBRARY_PATH 	\$OMPI/lib/
prepend-path    MANPATH         	\$OMPI/share/man
EOF


}

function post_install_configuration {
	mkdir -p /var/spool/slurmd/
	chown slurm /var/spool/slurmd	
	#Remove strict host key checking blindly
	echo "Host *" >> /etc/ssh/ssh_config
	echo "	StrictHostKeyChecking no" >> /etc/ssh/ssh_config
	#sed -i '/disable_root:/c\disable_root:0' /etc/cloud/cloud.cfg		
	sed -i 's/^disable_root .*$/disable_root: 0/' /etc/cloud/cloud.cfg
	#Configure Modules
	mkdir -p /apps/Modules/modulefiles/
 	grep /apps /usr/share/Modules/init/.modulespath | grep -v "#"
	if [ $? -ne 0 ]; then
		echo /apps/Modules/modulefiles >> /usr/share/Modules/init/.modulespath
	fi	

}

function generate_keys {
	if [ ! -f /root/.ssh/id_rsa ]; then
		ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
	fi
        if [ ! -f /etc/munge/munge.key ]; then
               /usr/sbin/create-munge-key 
        fi	
}

function start_services {
	chkconfig rpcbind on
	service rpcbind start
	chkconfig munge on
	chkconfig nfs on
	service munge start
	service nfs start


}

# We use munge. There is no need. 
function job_creds {
	openssl genrsa -out /opt/slurm/etc/slurm.key 1024
	chown slurm:slurm /opt/slurm/etc/slurm.key
	chmod 0400 /opt/slurm/etc/slurm.key
	openssl rsa -in /opt/slurm/etc/slurm.key -pubout -out /opt/slurm/etc/slurm.cert
	chmod 0444 /opt/slurm/etc/slurm.cert

}
function help {
	echo "Usage: $0 -i [--from-image]"
	echo "-i [--from-image]: Recommended if you are using pre-built image from NeCTAR/Tenjin e.g. compute-hpc-20150910"
	echo "-b [--build-image]: Use this option when building your own image. e.g. you are building an image from offical NeCTAR images "
	echo "-h [--help]: Display help"
}

function iptables_own {
        for iaddr in `/sbin/ip addr | grep inet | grep -v "::" | grep -v "127.0.0.1" | awk '{print $2}' | cut -d "/" -f1`; do
                sed -i "/INPUT -j REJECT --reject-with icmp-host-prohibited/i -A INPUT -s $iaddr -j ACCEPT" /etc/sysconfig/iptables
        done
}

function perform_update {
	yum update -y
}

function copy_apps {
	/usr/bin/rsync -av /contrib/slurm /opt/
	/usr/bin/rsync -av /contrib/openmpi /apps/
	/usr/bin/rsync -av /contrib/Modules /apps/
	/usr/bin/rsync -av /contrib/slurm-home/ /home/
        #Setup OpenMPI Module in /apps/Modules/modulefiles
        mkdir -p /apps/Modules/modulefiles/openmpi/
        cat > /apps/Modules/modulefiles/openmpi/1.10.0 << EOF
#%Module1.0#####################################################################
##
## standalone modulefile
##
proc ModulesHelp { } {
        global ompiver

        puts stderr "\tAdds OpenMPI $ompiver path"
        puts stderr "\n\tVersion $ompiver\n"
}
 
module-whatis    "OpenMPI. You have to know what it is! :)"
 
# for Tcl script use only
set     ompiver 1.10.0

set             OMPI                    /apps/openmpi/\$ompiver
setenv          OMPI                    \$OMPI
setenv          OPAL_PREFIX             \$OMPI
setenv          MPI_HOME                \$OMPI
append-path     PATH                    \$OMPI/bin/
prepend-path    LD_LIBRARY_PATH         \$OMPI/lib/
prepend-path    MANPATH                 \$OMPI/share/man
EOF

}
function build_scratch {
	house_keeping
	install_packages
	install_openstack_client
	post_install_configuration
	check_data_fs
	create_fs_base
	bind_mount
	download_slurm
	install_slurm
	install_openmpi_1.10.0
	#job_creds
	generate_keys
	iptables_own
	start_services
	echo "HeadNode is ready... you may provision the cluster"
}

function from_image {
	house_keeping
	check_data_fs
	create_fs_base
	bind_mount
	copy_apps
	#job_creds
	generate_keys
	iptables_own
	start_services
	perform_update
	echo "HeadNode is ready... you may provision the cluster"
}
if [ $# -ne 1 ]; then
	help
	exit 0
fi

key="$1"
case $key in
    -i|--from-image)
    from_image
    ;;
    -b|--build-image)
    echo "BUILD image from scratch"
    build_scratch
    ;;
    -h|--help)
    help
    ;;
    *)
            # unknown option
     help
    ;;
esac

