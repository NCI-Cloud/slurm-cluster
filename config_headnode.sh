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

SLURM_WGET="http://www.schedmd.com/download/latest/slurm-15.08.11.tar.bz2"
OPENMPI_WGET="https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.gz"
NFS_PART="nothing"

function install_packages {
	yum install -y acl acpid alsa-lib apr apr-util atk attr audit audit-libs audit-libs-python authconfig autoconf automake avahi-libs b43-openfwwf basesystem bash bc binutils blas blas-devel busybox byacc bzip2 bzip2-devel bzip2-libs bzip2-libs ca-certificates cairo centos-release checkpolicy chkconfig cloog-ppl cloud-init cloud-utils cloud-utils-growpart clustershell ConsoleKit ConsoleKit-libs coreutils coreutils-libs cpio cpp cracklib cracklib-dicts cronie cronie-anacron crontabs cscope ctags cups cups-libs curl cvs cyrus-sasl cyrus-sasl-lib dash db4 db4 db4-cxx db4-devel db4-utils dbus dbus-glib dbus-libs deltarpm desktop-file-utils device-mapper device-mapper-libs dhclient dhcp-common diffstat diffutils dmidecode doxygen dracut dracut-kernel dracut-modules-growroot e2fsprogs e2fsprogs-libs ed efibootmgr eggdbus elfutils elfutils-libelf elfutils-libs environment-modules epel-release ethtool euca2ools expat expat fail2ban fedora-usermgmt fedora-usermgmt-core fedora-usermgmt-default-fedora-setup fedora-usermgmt-shadow-utils file file-libs filesystem findutils fipscheck fipscheck-lib flac flex fontconfig fontconfig-devel freetype freetype-devel gamin gamin-python gawk gcc gcc-c++ gcc-gfortran GConf2 gdb gdbm gdbm gdbm-devel gdk-pixbuf2 gettext gettext-devel gettext-libs ghc-array ghc-base ghc-base64-bytestring ghc-binary ghc-blaze-builder ghc-blaze-html ghc-bytestring ghc-citeproc-hs ghc-containers ghc-deepseq ghc-digest ghc-directory ghc-extensible-exceptions ghc-filepath ghc-highlighting-kate ghc-HTTP ghc-json ghc-mtl ghc-network ghc-old-locale ghc-old-time ghc-pandoc-types ghc-parsec ghc-pcre-light ghc-pretty ghc-process ghc-random ghc-syb ghc-tagsoup ghc-temporary ghc-texmath ghc-text ghc-time ghc-transformers ghc-unix ghc-utf8-string ghc-xml ghc-zip-archive ghc-zlib ghostscript ghostscript-fonts giflib git glib2 glibc glibc glibc-common glibc-devel glibc-headers glusterfs glusterfs-api glusterfs-libs gmp gnupg2 gnutls gpgme gpg-pubkey gpm-libs grep gridengine gridengine-devel gridengine-execd gridengine-qmaster gridengine-qmon groff grub grubby gtk2 gzip heat-cfntools hicolor-icon-theme hwdata hwloc hwloc-devel indent info initscripts intltool iproute ipset iptables iptables-ipv6 iputils jasper-libs java-1.6.0-openjdk java-1.6.0-openjdk-devel java-1.7.0-openjdk jemalloc jline jpackage-utils kbd kbd-misc kernel kernel kernel-devel kernel-firmware kernel-headers kexec-tools keyutils keyutils-libs keyutils-libs keyutils-libs-devel kpartx kpathsea krb5-devel krb5-libs krb5-libs ksh lapack lapack-devel lcms-libs less libacl libaio libart_lgpl libasyncns libattr libblkid libcap libcap-ng libcgroup libcom_err libcom_err libcom_err-devel libcurl libdrm libedit libevent libffi libffi libffi-devel libfontenc libgcc libgcj libgcrypt libgfortran libgomp libgpg-error libgssglue libibverbs libibverbs-devel libibverbs-utils libICE libicu libicu-devel libIDL libidn libjpeg-turbo libmlx4 libmlx5 libmnl libnih libnl libogg libpcap libpciaccess libpng libpng-devel libproxy libproxy-bin libproxy-python librdmacm librdmacm-utils libRmath libRmath-devel libselinux libselinux libselinux-devel libselinux-python libselinux-utils libsemanage libsemanage-python libsepol libsepol-devel libSM libsndfile libss libssh2 libstdc++ libstdc++-devel libtasn1 libthai libtiff libtirpc libtool libudev libusb libusb1 libuser libutempter libuuid libvorbis libX11 libX11-common libX11-devel libXau libXau-devel libxcb libxcb-devel libXcomposite libXcursor libXdamage libXext libXfixes libXfont libXft libXft-devel libXi libXinerama libxml2 libxml2-devel libxml2-python libXmu libXp libXpm libXrandr libXrender libXrender-devel libXt libXtst libyaml logrotate lua lzo m2crypto m4 mailcap make MAKEDEV man mdadm mingetty module-init-tools mpfr mstflint munge munge-devel munge-libs mysql-libs nano ncurses ncurses-base ncurses-devel ncurses-libs ncurses-libs neon netpbm netpbm-progs net-tools newt newt-python nfs-utils nfs-utils-lib nmap nspr nss nss-softokn nss-softokn-freebl nss-softokn-freebl nss-sysinit nss-tools nss-util ntp ntpdate numactl numactl-devel openjpeg-libs openldap openmotif openssh openssh-clients openssh-server openssl openssl openssl-devel ORBit2 p11-kit p11-kit-trust pakchois pam pandoc pango passwd patch patchutils pciutils pciutils-devel pciutils-libs pcre pcre-devel pcsc-lite-libs perl perl-Compress-Raw-Zlib perl-Compress-Zlib perl-CPAN perl-devel perl-Digest-SHA perl-Error perl-ExtUtils-MakeMaker perl-ExtUtils-ParseXS perl-Git perl-HTML-Parser perl-HTML-Tagset perl-IO-Compress-Base perl-IO-Compress-Zlib perl-libs perl-libwww-perl perl-Module-Pluggable perl-Pod-Escapes perl-Pod-Simple perl-Switch perl-Test-Harness perl-URI perl-version perl-XML-Parser pinentry pixman pkgconfig plymouth plymouth-core-libs plymouth-scripts policycoreutils policycoreutils-python polkit poppler poppler-data poppler-utils popt portreserve postfix ppl procps psmisc psutils pth pulseaudio-libs pygpgme python python-argparse python-backports python-backports-ssl_match_hostname python-boto python-chardet python-cheetah python-configobj python-crypto python-devel python-imaging python-iniparse python-inotify python-jsonpatch python-jsonpointer python-libs python-libs python-markdown python-oauth python-paramiko python-pip python-prettytable python-psutil python-pycurl python-pygments python-requests python-rsa python-setuptools python-six python-urlgrabber python-urllib3 PyYAML qemu-img R R-core R-core-devel rcs R-devel rdma readline readline redhat-logos redhat-rpm-config rhino R-java R-java-devel rootfiles rpcbind rpm rpm-build rpm-libs rpm-python rsync rsyslog sed selinux-policy selinux-policy-targeted setools-libs setools-libs-python setup sgml-common shadow-utils shared-mime-info slang snappy sqlite sqlite sqlite-devel strace subversion sudo swig system-config-firewall-base system-config-firewall-tui systemtap systemtap-client systemtap-devel systemtap-runtime sysvinit-tools tar tcl tcl-devel tcp_wrappers-libs tcsh telnet texinfo texinfo-tex texlive texlive-dvips texlive-latex texlive-texmf texlive-texmf-dvips texlive-texmf-errata texlive-texmf-errata-dvips texlive-texmf-errata-fonts texlive-texmf-errata-latex texlive-texmf-fonts texlive-texmf-latex texlive-utils tex-preview tk tk-devel tmpwatch ttmkfdir tuned tzdata tzdata-java udev unzip upstart urw-fonts usbredir usermode ustr util-linux-ng vim-common vim-enhanced vim-filesystem vim-minimal wget which xdg-utils xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-Type1 xorg-x11-font-utils xorg-x11-proto-devel xz xz-devel xz-libs xz-lzma-compat yum yum-metadata-parser yum-plugin-fastestmirror yum-presto zip zlib zlib zlib-devel
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
	cp ../slurm.conf.template /opt/slurm/etc/slurm.conf
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

function install_openmpi_1.10.2 {
        if [ -d /apps/openmpi/1.10.2 ]; then
                echo OpenMPI-1.10.2 found... Using existing at /apps/openmpi/1.10.2
                return 1
        fi
	Ret=$(wget $OPENMPI_WGET)
        PWD=$(pwd)
        fname=$(basename $OPENMPI_WGET)
        dirname=$(tar -tf $fname  | head -1)
        tar -xvf $fname
        echo $dirname
        cd $dirname
        ./configure --prefix=/apps/openmpi/1.10.2 --enable-shared --enable-builtin-atomics --enable-mpi-thread-multiple --enable-mca-no-build=portals4,portals,elan,usnic --with-verbs --enable-orterun-prefix-by-default
        make && make install
        if [ $? -ne 0 ]; then
                echo OpenMPI-1.10.2 compilation filed.. Exiting
                exit 1
        fi
	
	#Setup OpenMPI Module in /apps/Modules/modulefiles
	mkdir -p /apps/Modules/modulefiles/openmpi/
	cat > /apps/Modules/modulefiles/openmpi/1.10.2 << EOF
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
set     ompiver 1.10.2

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

function pbs_server_conf {
cat > /etc/pbs.conf << EOF
PBS_SERVER=`hostname`
PBS_START_SERVER=1
PBS_START_SCHED=1
PBS_START_COMM=1
PBS_START_MOM=0
PBS_EXEC=/opt/pbs
PBS_HOME=/var/spool/pbs
PBS_CORE_LIMIT=unlimited
PBS_SCP=/usr/bin/scp
EOF

}

function copy_apps {
	/usr/bin/rsync -av /contrib/slurm /opt/
        /usr/bin/rsync -av /contrib/pbs /opt/
	/usr/bin/rsync -av /contrib/openmpi /apps/
	/usr/bin/rsync -av /contrib/Modules /apps/
	/usr/bin/rsync -av /contrib/slurm-home/ /home/
        #Setup OpenMPI Module in /apps/Modules/modulefiles
        mkdir -p /apps/Modules/modulefiles/openmpi/
        cat > /apps/Modules/modulefiles/openmpi/1.10.2 << EOF
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
set     ompiver 1.10.2

set             OMPI                    /apps/openmpi/\$ompiver
setenv          OMPI                    \$OMPI
setenv          OPAL_PREFIX             \$OMPI
setenv          MPI_HOME                \$OMPI
append-path     PATH                    \$OMPI/bin/
prepend-path    LD_LIBRARY_PATH         \$OMPI/lib/
prepend-path    MANPATH                 \$OMPI/share/man
EOF

}

# This function does not build PBSPro.. we will fix it later. 
# Simply following instructions at PBSPro github repo for build instructions
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
	install_openmpi_1.10.2
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
	pbs_server_conf
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

