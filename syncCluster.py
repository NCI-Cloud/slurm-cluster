#!/usr/bin/env python
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

import os
import time
import sys
import subprocess
import fileinput
import ConfigParser
import optparse
import sqlite3

DBNAME="biocluster.db"
CLUSTER_NAME="biocluster"
CLUSTER_CFG="cluster.cfg"

def parse_conf(confFile):
        config = ConfigParser.RawConfigParser()
        config.read(confFile)
        global CLUSTER_NAME
        CLUSTER_NAME = config.get('Cluster','CLUSTER_NAME')

def update_db(id, name, ip):
        db = CLUSTER_NAME + ".db"
        conn = sqlite3.connect(db)
        sSQL = "INSERT INTO NODES (ID, NAME, IP_ADDR_EXT) values ('" + str(id) + "', '" + str(name) + "', '" + str(ip) + "')"
        conn.execute(sSQL)
        conn.commit()
        conn.close()

def sync_cluster():
	parse_conf(CLUSTER_CFG)
        db = CLUSTER_NAME + ".db"
	with sqlite3.connect(db) as conn:
		cursor = conn.cursor()
        	sSQL = "Select NAME from  NODES"
		cursor.execute(sSQL)
		for row in cursor.fetchall():
			nodeName = row[0]
			proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/sysconfig/iptables", str(nodeName) + ":/etc/sysconfig/"], stdout=subprocess.PIPE,  shell=False)
        		proc.wait()
                        proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/hosts", str(nodeName) + ":/etc/"], stdout=subprocess.PIPE,  shell=False)
                        proc.wait()
			proc = subprocess.Popen(["ssh", nodeName ,"service" ,"iptables" ,"restart"], stdout=subprocess.PIPE, shell=False)
        		proc.wait()
		
			proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/group", str(nodeName) + ":/etc/"], stdout=subprocess.PIPE,  shell=False)
                        proc.wait()
			proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/passwd", str(nodeName) + ":/etc/"], stdout=subprocess.PIPE,  shell=False)
                        proc.wait()
			proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/shadow", str(nodeName) + ":/etc/"], stdout=subprocess.PIPE,  shell=False)
                        proc.wait()
        		print ("%s: Hosts, Users, Groups and iptables updated...") %(nodeName)
        conn.close()


def main():
        parser = optparse.OptionParser()
        parser.add_option('-c', '--config', dest='config', default='cluster.cfg' , help='Use different configuration file (default: cluster.cfg)')
	global CLUSTER_CFG
        (opts, args) = parser.parse_args()
        if opts.config is not None:
                CLUSTER_CFG=str(opts.config)
	print "Syncing..."
	sync_cluster()


if __name__ == '__main__':
    main()
           

