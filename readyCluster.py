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


def services(nodeName):
        print "Starting Services on Node:  %s" %(nodeName)
	proc = subprocess.Popen(["ssh" , nodeName, "mkdir", "-p", "/var/slurm/log"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["ssh" , nodeName, "mount", "-a"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/munge/munge.key", str(nodeName) + ":/etc/munge/"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/sysconfig/iptables", str(nodeName) + ":/etc/sysconfig/"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/etc/hosts", str(nodeName) + ":/etc/"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["/usr/bin/rsync", "-av", "/opt/pbs", str(nodeName) + ":/system"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        proc = subprocess.Popen(["ssh", nodeName ,"service" ,"iptables" ,"restart"], stdout=subprocess.PIPE, shell=False)
        proc.wait()
        proc = subprocess.Popen(["ssh", nodeName ,"service" ,"munge" ,"start"], stdout=subprocess.PIPE, shell=False)
        proc.wait()
        proc = subprocess.Popen(["ssh", nodeName, "service", "pbs", "restart"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()
        print ("We have only started PBS; however slurm has been configured")
	DEVNULL = open(os.devnull, 'w')
	proc = subprocess.Popen(["/opt/slurm/bin/scontrol","update", "NodeName=" + nodeName, "State=RESUME"], stdout=DEVNULL, stderr=subprocess.STDOUT,  shell=False)
        proc.wait()
	print ("Services restarted")

def start_services():

	parse_conf(CLUSTER_CFG)
	proc = subprocess.Popen(["service", "slurm", "restart"], stdout=subprocess.PIPE,  shell=False)
	proc.wait()

        db = CLUSTER_NAME + ".db"
	with sqlite3.connect(db) as conn:
		cursor = conn.cursor()
        	sSQL = "Select NAME from  NODES"
		cursor.execute(sSQL)
		for row in cursor.fetchall():
			nodeName = row[0]
        		services(nodeName)
        conn.close()

def stop_services():
	print "Nothing implemented here. Add your own code here e.g. stop NFS services etc"

def main():
        parser = optparse.OptionParser()
        parser.add_option('-c', '--config', dest='config', default='cluster.cfg' , help='Use different configuration file (default: cluster.cfg)')
        parser.add_option('-s', '--start', action="store_true", default=False , help='Start services accross the entire cluster and enable the queue')
        parser.add_option('-n', '--node', action="store", default=False , type="string", help='Start services on an individual node')
        parser.add_option('-t', '--stop', action="store_false", default=False , help='Stops the cluster queue')
	global CLUSTER_CFG
        (opts, args) = parser.parse_args()
        if opts.start and opts.stop:
                print "Options -s and -t are mutually exclusive"
                sys.exit(0)
        if opts.config is not None:
                CLUSTER_CFG=str(opts.config)
        if opts.start == True:
                start_services()
        elif opts.stop == True:
                stop()
	elif len(opts.node) > 0:
		services(str(opts.node))
	else:
	        parser.print_help()
                sys.exit(0)	

if __name__ == '__main__':
    main()
           

