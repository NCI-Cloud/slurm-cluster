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

TODAY=$(date +"%y%m%d")
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /root/.ssh/id_rsa*
rm -f /root/.ssh/authorized_keys
rm -f /root/.ssh/known_hosts
rm -f /etc/munge/munge.key
echo NETWORKING=yes > /etc/sysconfig/network
#rm /root/ncicluster -rf
echo "yanked" > /root/.bash_history
rm -rf /root/.cache/*
rm -rf /root/.novaclient/*
cat /dev/null > ~/.bash_history 
history -c
echo "-------------------------------------------------------"
echo "Please manually check /etc/fstab for fixed mount points"
echo "-------------------------------------------------------"
echo "Please go to OpenStack dashboard, shutdown the instance and create a snapshop"
echo "Refer to documentation for more details"


