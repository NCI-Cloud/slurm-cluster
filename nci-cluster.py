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

#TODO: python2.7 port as python2.6 is being depricated. Centos 6.X is still supported and so is its python2.6 by RHEL; but python developers are no longer supporting 2.6.

import os
import time
import sys
import subprocess
import fileinput
import ConfigParser
import optparse
import sqlite3
from shutil import move
from shutil import copyfile
import novaclient.v2.client as nvclient
import netifaces as ni
import ConfigParser
import calendar
import time
import socket 
import base64
import hashlib
from cinderclient.v2 import client as ciclient
from credentials import get_nova_creds
from credentials import get_cinder_creds
import urllib3.contrib.pyopenssl
urllib3.contrib.pyopenssl.inject_into_urllib3()

CLUSTER_CFG = "cluster.cfg"
CLUSTER_NAME = "mycluster"
#bug: Node name has to be all lower case.
INSTANCE_NAME = "x"
CLUSTER_RANGE_START=1
CLUSTER_COMPUTE_SIZE=4
MAX_CLUSTER_SIZE=10
KEY_NAME = "mykey"
#IMAGE_NAME = "cluster-compute-v1"
IMAGE_NAME = "compute-DATE"
FLAVOUR_NAME = "t2.2c4m20d"
#FLAVOUR_NAME = "m2.medium"
AVAILABILITY_ZONE = "nova"
#major confusion? nova network-list ub2
NETWORK_NAME = "66ca03f9-6faa-48c3-bc0c-dbfe6966f141"
NCI_CLUSTER_VOLUME = 'NCI_CLUSTER_MXA_TEST'
COMPUTE_CLOUD_INIT = "cloud_init.sh"
SLURM_HOME="/opt/slurm/"
CLUSTER_OPT="/opt/"
CLUSTER_NFS="/data"
SLURM_PART="Cloud1"
SECURITY_GROUP="hpcincloud"

#Other variables that are not in cfg file

def set_nfs_exports(ipaddr):
	# This sounds line a strange algo. Open the file as RO and in the loop change
	# its contents but still keep going. 
	# Better idea is to read the entire file in mem, change the contents and write in 
	# one go... Ugly hack, will fix when I get $TIME
	x=0
        f = open("/etc/exports", 'r')
	for line in f:
		if str("/apps") in line and str(ipaddr) not in line:
			newExport = line[:-1] + " " +  str(ipaddr) + "(rw,sync)\n"
			replace_line("/etc/exports",line,newExport)
			x+=1
                if str("/home") in line and str(ipaddr) not in line:
                        newExport = line[:-1] + " " +  str(ipaddr) + "(rw,sync)\n"
                        replace_line("/etc/exports",line,newExport)
			x+=1
                if str("/opt") in line and str(ipaddr) not in line:
                        newExport = line[:-1] + " " +  str(ipaddr) + "(rw,sync)\n"
                        replace_line("/etc/exports",line,newExport)
			x+=1
                if str("/short") in line and str(ipaddr) not in line:
                        newExport = line[:-1] + " " +  str(ipaddr) + "(rw,sync)\n"
                        replace_line("/etc/exports",line,newExport)	
			x+=1
		if str("/system") in line and str(ipaddr) not in line:
                        newExport = line[:-1] + " " +  str(ipaddr) + "(rw,sync)\n"
                        replace_line("/etc/exports",line,newExport)
                        x+=1
	f.close()
def empty_file(fileName):
	with open(fileName, "w"):
       		pass

def prep_nfs_exports():
	distroy_nfs_exports()
	f = open("/etc/exports",'w')
	f.write("/data/apps\n/data/home\n/data/opt\n/data/short\n/data/system\n")
	f.close()

def distroy_nfs_exports():
	empty_file("/etc/exports")	

def restart_headnode_services():
        proc = subprocess.Popen(["service", "nfs", "restart"], stdout=subprocess.PIPE, shell=False)
        proc.wait()
        proc = subprocess.Popen(["service", "iptables", "restart"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()

#better way to create from scratch?
def set_firewall(ipAddr):
	for line in fileinput.input('/etc/sysconfig/iptables', inplace=True):
    		if line.strip() == '-A INPUT -j REJECT --reject-with icmp-host-prohibited':
        		print '-A INPUT -s ' + str(ipAddr) +  ' -j ACCEPT'
    		print line,
	#p = subprocess.Popen(["cat", "/etc/sysconfig/iptables"], shell=False)		
        proc = subprocess.Popen(["service", "iptables", "restart"], stdout=subprocess.PIPE, shell=False)
        proc.wait()
        #print ("Service IPTABLES restarted\n")

def create_hosts_file():
	file = open ('/etc/hosts','w')
        buf = "::1      localhost       localhost.localdomain   localhost6      localhost6.localdomain6\n127.0.0.1      localhost       localhost.localdomain   localhost4      localhost4.localdomain4\n"
        file.write (buf)
	buf = str(get_host_ip()) + "   " +  str(os.uname()[1]) + "\n"
	file.write(buf)
	file.close()
	


def set_hostsfile(ipAddr,instance_name):
	file = open ('/etc/hosts','a')
	buf = "%s    %s \n" % (str(ipAddr), instance_name) 
	file.write (buf)

def launch_instance(nova,instance_name, user_data_init):
	try:
		image = nova.images.find(name=IMAGE_NAME)
	except:
		print "Image %s not found... please check image name." %(IMAGE_NAME)
                e = sys.exc_info()[1]
                print "Error: %s " % e
		sys.exit(1)
	#image = nova.images.find(name=IMAGE_NAME)
	try:
		flavor = nova.flavors.find(name=FLAVOUR_NAME)
	except:
		print "Flavour %s not found... please check available flavours." %(FLAVOUR_NAME)
                e = sys.exc_info()[1]
                print "Error: %s " % e
		sys.exit(1)
	# OpenStack documentation makes Microsoft documentation looks like it was written by God!
	try:	
        	instance = nova.servers.create(name=instance_name, image=image, flavor=flavor, availability_zone=AVAILABILITY_ZONE, userdata=user_data_init, key_name=KEY_NAME, security_groups=SECURITY_GROUP)
	except:
		print "Error launching the instance..."
		e = sys.exc_info()[1]
                print "Error: %s " % e
		sys.exit(1)
	# Poll at 5 second intervals, until the status is no longer 'BUILD'
	status = instance.status
	while status == 'BUILD':
        	time.sleep(5)
       		 # Retrieve the instance again so the status field updates
        	instance = nova.servers.get(instance.id)
        	status = instance.status
        	if status == 'ERROR':
                	print "Could not launch instance: %s. Exiting" %instance.id
			sys.exit(1)
	
        tmp_ip=nova.servers.ips(instance)
	#print tmp_ip
	#SHould have a loop and then exit if IP does not get assinged. New NeCTAR nodes had difficulty.
	if not tmp_ip:
		#actually put a loop to check . I am doing in if to check for more errors that con arise
		time.sleep(10)
		tmp_ip=nova.servers.ips(instance)

	#print tmp_ip
	ipAddr = tmp_ip.itervalues().next()[0]["addr"]
	print "Launched instance %s with IP Address %s - status: %s" % (instance.id, ipAddr, status)
	#print ("Setting up NFS exports for the instance")
	set_firewall(ipAddr)
	set_nfs_exports(ipAddr)
	set_hostsfile(ipAddr, instance_name)
	restart_headnode_services()
 	return instance.id, instance_name, ipAddr	

def cinder_volume_create(c_conn):
	volume = c_conn.volumes.create(1, name='myvolume', description='NCI Cluster Volume')

def setup_slurmhead():
	buf = "ControlMachine=" + str(os.uname()[1]) + "\n"
	fileName=str(SLURM_HOME) + "/etc/slurm.conf"
	replace_line(fileName,'ControlMachine=',buf)
	buf = "NodeName=" +INSTANCE_NAME + "[0-" + str(MAX_CLUSTER_SIZE) + "] State=UNKNOWN\n"
	replace_line(fileName,'NodeName=',buf)
	buf = "PartitionName=" + str(SLURM_PART) + " Nodes=" + INSTANCE_NAME + "[0-" + str(MAX_CLUSTER_SIZE) + "] Default=YES MaxTime=INFINITE State=UP\n"
	replace_line(fileName,'PartitionName=',buf)

def replace_line(input,pattern,replacement):
	inp = open(input, 'r')
	outputfile = input + ".conf.swp"
	#print outputfile + " " + input
	outp = open(outputfile, 'w')
	for line in inp:
        	if pattern in line:
            		#print line
            		outp.write(replacement)
        	else:
            		outp.write(line)
	inp.close()
	outp.close()
	move(outputfile,input)

def remove_line(input, pattern):
	inp = open(input, 'r')
        outputfile = input + ".conf.swp"
        outp = open(outputfile, 'w')
        for line in inp:
                if not pattern in line:
                        outp.write(line)
        inp.close()
        outp.close()
        move(outputfile,input)

def replace_string_line(input,pattern):
        inp = open(input, 'r')
        outputfile = input + ".conf.swp"
        outp = open(outputfile, 'w')
        for line in inp:
                if pattern in line:
                        line = line.replace(pattern," ")
			outp.write(line)
		else:
			outp.write(line)
        inp.close()
        outp.close()
        move(outputfile,input) 

def get_host_ip():
	ni.ifaddresses('eth0')
        ip = ni.ifaddresses('eth0')[2][0]['addr']	
	return str(ip)

def get_head_public_key():
	f=open("/root/.ssh/id_rsa.pub",'r')
	public_key=f.read()
	return public_key
#nova.servers.create(name="samplehost", image=image, flavor=flavor,nics=[{'net-id': '9883ec93-4589-4fa2-825d-7a9a8215fd07'}])
#This should be inside a variable not a file and then read as a variable. Lame, but blame it on OS documentation which was poor.

def compute_cloud_init():
    ni.ifaddresses('eth0')
    ip = ni.ifaddresses('eth0')[2][0]['addr']
    strCloudInit = "#!/bin/bash\n"
    strCloudInit = strCloudInit + "echo HeadNode=" + os.uname()[1] + " > /tmp/CloudInit" + "\n"
    strCloudInit = strCloudInit + "echo HeadNodeIP=" + str(ip) + " >> /tmp/CloudInit" + "\n"
    strCloudInit = strCloudInit + "sed -i '/" + str(ip) + "/d' /etc/hosts\n"
    strCloudInit = strCloudInit + "echo " + str(ip) + "  " + os.uname()[1] + ">> /etc/hosts\n"
    strCloudInit = strCloudInit + "sed -i '/--dport 22 -j ACCEPT/a -A INPUT -s " + str(ip) + " -j ACCEPT' /etc/sysconfig/iptables"
    strCloudInit = strCloudInit + "\n"
    strCloudInit = strCloudInit + "service iptables restart\n"
    strCloudInit = strCloudInit + "mkdir -p /short; mkdir -p /apps; mkdir -p /jobfs/local/ \n"
    strCloudInit = strCloudInit + "echo " + str(ip) + ":/data/short /short nfs hard,intr,rw,rsize=2048,wsize=2048,nfsvers=3 0 0 >> /etc/fstab\n"
    strCloudInit = strCloudInit + "echo " + str(ip) + ":/data/apps  /apps  nfs hard,intr,ro,rsize=2048,wsize=2048,nfsvers=3 0 0 >> /etc/fstab\n"
    strCloudInit = strCloudInit + "echo " + str(ip) + ":/data/home  /home nfs   hard,intr,rw,rsize=2048,wsize=2048,nfsvers=3 0 0 >> /etc/fstab\n"
    strCloudInit = strCloudInit + "echo " + str(ip) + ":/data/opt   /opt   nfs hard,intr,ro,rsize=2048,wsize=2048,nfsvers=3 0 0 >> /etc/fstab\n"
    strCloudInit = strCloudInit + "echo /apps/Modules/modulefiles  >> /usr/share/Modules/init/.modulespath" + "\n"
    strCloudInit = strCloudInit + "mount -a \n"
    #not implemented
    strCloudInit = strCloudInit + "if [ -s /opt/etc/hosts ]; then\n"
    strCloudInit = strCloudInit + "   ln -s /opt/etc/hosts /etc/hosts -f\n"
    strCloudInit = strCloudInit + "fi\n"
    return (strCloudInit)


def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")

def create_cluster_db():
	db = CLUSTER_NAME + ".db"
	if os.path.isfile(db):
		ret = query_yes_no("Previous cluster database exists and will be deleted. Are you sure you want to proceed?", "no")
		if ret == False:
			print "Exiting... \n"
			sys.exit(0)
		else:
			os.remove(db)
	conn = sqlite3.connect(db)
	conn.execute('''CREATE TABLE NODES
       			(ID TEXT PRIMARY KEY     NOT NULL,
      			NAME           TEXT    NOT NULL,
       			IP_ADDR_EXT    TEXT     NOT NULL,
       			IP_ADDR_INT    TEXT);''')
	conn.close()

def update_db(id, name, ip):
	db = CLUSTER_NAME + ".db"
        conn = sqlite3.connect(db)
	sSQL = "INSERT INTO NODES (ID, NAME, IP_ADDR_EXT) values ('%s','%s','%s')" %(str(id),str(name),str(ip))
	conn.execute(sSQL)
	conn.commit()
	conn.close()

def remove_node_db(name):
        db = CLUSTER_NAME + ".db"
        conn = sqlite3.connect(db)
        sSQL = "delete from nodes where name = '%s'" %(name)
        conn.execute(sSQL)
        conn.commit()
        conn.close()

def next_node(name):
        db = CLUSTER_NAME + ".db"
        conn = sqlite3.connect(db)
	cur = conn.cursor()
	sSQL = "select max(replace(name,'%s','')) from nodes" %(name)
        cur.execute(sSQL)
        result = cur.fetchone()
        conn.close()
	return result[0]

def check_munge():
		
	if os.path.exists("/etc/munge/munge.key"):
		print ("Munge Key Found... using the key\n")
	else:
		print ("Creating Munge Key...\n")
		try:
			proc = subprocess.Popen(["create-munge-key"], stdout=subprocess.PIPE, shell=False)
        		proc.wait()
		except:
			e = sys.exc_info()[1]
    			print "Error: %s (create-munge-key)" % e
			sys.exit(1)
	
	try:
		pout = subprocess.Popen(["service", "munge" , "status"], stdout=subprocess.PIPE, shell=False).communicate()[0]
		if "running" not in pout:
			#Munge crashes at times. It is better for the researcher to start munge and this program check the status. 
			#Next version we will start munge and check
			print ("Munge Daemon not running\n Use \'service munge start\' and try again.\n")
	except:
		e = sys.exc_info()[1]
                print "Error: %s " % e
                sys.exit(1)
		#except subprocess.CalledProcessError
	

def destroy():
    strKey="This will terminate your cluster compute nodes... Are you sure?"
    ret = query_yes_no(strKey, "no")
    if ret == True:
        print ("Reading Config File (%s)...") %(CLUSTER_CFG)
        parse_conf(CLUSTER_CFG)
        db = CLUSTER_NAME + ".db"
        conn = sqlite3.connect(db)
        sSQL = "SELECT ID, NAME, IP_ADDR_EXT FROM NODES"
        result = conn.execute(sSQL)
        creds = get_nova_creds()
        nova = nvclient.Client(**creds)
        for row in result:
            print "Terminating instance (%s)- %s with IP %s " %(str(row[0]), str(row[1]), str(row[2]))
            try:
                    ret = nova.servers.delete(str(row[0]))
            except:
                    print "Error terminating the instance..."
                    e = sys.exc_info()[1]
                    print "Error: %s " % e
                    #sys.exit(0)
	    try:
		    print str(row[2])
        	    remove_line("/etc/sysconfig/iptables",str(row[2]))	
	    except:
		    print "Error removing the iptables entry for %s... please remove manually" %(str(row[2]))
		    e = sys.exc_info()[1]
                    print "Error: %s " % e
        
        empty_file("/etc/exports")
        print "NFS Exports file entries have been removed..."
        proc = subprocess.Popen(["service", "nfs", "stop"], stdout=subprocess.PIPE, shell=False)
        #print 'poll =', proc.poll(), '("None" means process not terminated yet)'
        proc.wait()
        proc = subprocess.Popen(["service", "iptables", "restart"], stdout=subprocess.PIPE,  shell=False)
        proc.wait()	
        conn.close()
        os.remove(db)	
    else:
        print "Exiting on user request"
        sys.exit(0)

#slurp all conig file in one go as global variable.
#not recommended but this is a script and no need to open same cfg again.

def parse_conf(confFile):
	config = ConfigParser.RawConfigParser()
	config.read(confFile)
	global CLUSTER_NAME
	global INSTANCE_NAME
	global CLUSTER_RANGE_START
	global CLUSTER_COMPUTE_SIZE
	global MAX_CLUSTER_SIZE
	global KEY_NAME
	global IMAGE_NAME
	global FLAVOUR_NAME
	global AVAILABILITY_ZONE
	global NETWORK_NAME
	global NCI_CLUSTER_VOLUME
	global COMPUTE_CLOUD_INIT
	global SLURM_HOME
	global CLUSTER_OPT
	global CLUSTER_NFS
	global SLURM_PART
	global SECURITY_GROUP
	CLUSTER_NAME = config.get('Cluster','CLUSTER_NAME')
	INSTANCE_NAME = config.get('Cluster','INSTANCE_NAME')
	CLUSTER_RANGE_START = config.getint('Cluster','CLUSTER_RANGE_START')
	CLUSTER_COMPUTE_SIZE = config.getint('Cluster','CLUSTER_COMPUTE_SIZE')
	MAX_CLUSTER_SIZE = config.getint('Cluster','MAX_CLUSTER_SIZE')
	KEY_NAME = config.get('Cluster','KEY_NAME')
	IMAGE_NAME = config.get('Cluster','IMAGE_NAME')
	FLAVOUR_NAME = config.get('Cluster','FLAVOUR_NAME')
	AVAILABILITY_ZONE = config.get('Cluster','AVAILABILITY_ZONE')
	NETWORK_NAME = config.get('Cluster','NETWORK_NAME')
	NCI_CLUSTER_VOLUME = config.get('Cluster','NCI_CLUSTER_VOLUME')
	COMPUTE_CLOUD_INIT = config.get('Cluster','COMPUTE_CLOUD_INIT')
	SLURM_HOME = config.get('Cluster','SLURM_HOME')
	CLUSTER_OPT = config.get('Cluster','CLUSTER_OPT')
	CLUSTER_NFS = config.get('Cluster','CLUSTER_NFS')
	SLURM_PART = config.get('Cluster','SLURM_PART')
	SECURITY_GROUP = config.get('Cluster','SECURITY_GROUP')

def config_clustersh():
	csh_group="/etc/clustershell/groups"
	nextNode=int(next_node(INSTANCE_NAME))
	if os.path.exists(csh_group):
		empty_file(csh_group)
		f = open(csh_group,"w")
		f.write("compute: " + str(INSTANCE_NAME) + "[" + str(CLUSTER_RANGE_START) + "-" + str(nextNode) + "]\n")
		f.write("all: " + str(INSTANCE_NAME) + "[" + str(CLUSTER_RANGE_START) + "-" + str(nextNode) + "]\n")
		f.close()


def create_keypair(nova):
        with open(os.path.expanduser('/root/.ssh/id_rsa.pub')) as fpubkey:
                try:
                        nova.keypairs.create(name=KEY_NAME, public_key=fpubkey.read())
                except:
                        print "Error creating keypair"
                        e = sys.exc_info()[1]
                        print "Error: %s " % e
                        sys.exit(0)

                print ("New OpenStack key (%s) based on /root/.ssh/id_rsa.pub was created...\n") %(str(KEY_NAME))

def get_fingerprint(line):
	key = base64.b64decode(line.strip().split()[1].encode('ascii'))
    	fp_plain = hashlib.md5(key).hexdigest()
    	return ':'.join(a+b for a,b in zip(fp_plain[::2], fp_plain[1::2]))
	
def check_keypair(nova):
	try:
		key=nova.keypairs.findall(name=KEY_NAME)
	except:
		print "Error seeking Keypair..."
	if key:
		keyFile=open("/root/.ssh/id_rsa.pub","r")
		keyLine=keyFile.readline()
		keyFingerprint=get_fingerprint(keyLine)
		if key[0].fingerprint == keyFingerprint:
			print "Key %s found..." %(KEY_NAME)
		else:
			print "Fingerprint of OpenStack key %s and %s do not match. Cluster tool cannot proceed with mismatched fingerprints.\n" %(KEY_NAME,"/root/.ssh/id_rsa.pub")
                        print " Fingerprint of OpenStack key %s: %s\n Fingerprint of /root/.ssh/id_rsa.pub: %s\n\n" %(KEY_NAME,str(key[0].fingerprint), str(keyFingerprint))
			strKey="We can delete previous %s and add your %s as a new key... Do you wish to proceed?" %(KEY_NAME,"/root/.ssh/id_rsa.pub")
                	ret = query_yes_no(strKey, "no")
                	if ret == True:
				try:
					nova.keypairs.delete(KEY_NAME)
				except:
					print "Could not delete the Keypair... Exiting"
					sys.exit(1)
				create_keypair(nova)
                	else:
                        	print "Keypairs do not match... refusing to continue"
				print "Please change the name of the key in %s file" %(CLUSTER_CFG)
				sys.exit(0)
	else:
		create_keypair(nova)
	

def create_secgroup(nova):
        seclist=nova.security_groups.list()
        secFound=0
        for item in seclist:
                if (str(item.name) == str(SECURITY_GROUP)):
                        print "Security group found (%s)..." %(SECURITY_GROUP)
                        secFound = 1
        if (secFound == 0):
                print "Creating Security group (%s)..." %(SECURITY_GROUP)
                nova.security_groups.create(SECURITY_GROUP,"hpc in the cloud")
                secgroup = nova.security_groups.find(name=SECURITY_GROUP)
                nova.security_group_rules.create(secgroup.id,
                               ip_protocol="tcp",
                               from_port=1,
                               to_port=65535)
		nova.security_group_rules.create(secgroup.id,
                               ip_protocol="udp",
                               from_port=1,
                               to_port=65535) 
               	nova.security_group_rules.create(secgroup.id,
                               ip_protocol="icmp",
                               from_port=-1,
                               to_port=-1)
	
def headnode_secgroup(nova):
	myname=socket.gethostname()
	me=nova.servers.find(name=str(myname))
	sec_found=0
	for group in me.security_groups:
		if group["name"] == SECURITY_GROUP:
			sec_found=1
			break
	if not sec_found:
		try:
			nova.servers.add_security_group(me.id,SECURITY_GROUP)
			print ("Added security group %s to %s" %(SECURITY_GROUP,myname))
		except:
			print ("Could not add the Security Group %s to HeadNode" %(SECURITY_GROUP))
			e = sys.exc_info()[0]
			print e
			sys.exit(1)

def verify_cluster(nova):
    print ("Verifying the cluster, please wait...")
    db = CLUSTER_NAME + ".db"
    conn = sqlite3.connect(db)
    sSQL = "SELECT ID, NAME, IP_ADDR_EXT FROM NODES"
    result = conn.execute(sSQL)
    server_list=nova.servers.list()
    #print server_list
    for row in result:
        print "Looking for instance (%s)- %s with IP %s " %(str(row[0]), str(row[1]), str(row[2]))
        try:
            ret = nova.servers.findall(name=str(row[1]))
        except:
            print "Error finding the instance %s" %(str(row[1]))
            e = sys.exc_info()[1]
            print "Error: %s " % e
            sys.exit(0)
	#print ret
	foundServer=0
        for server in ret:
	    #print server.name
	    #print server.id
	    if server.id == str(row[0]):
                foundServer=1
		if server.status != 'ACTIVE':
			print "Instance is not active"
        if foundServer==0:
		print ("Instance (%s) - %s with IP %s  not found... verification for the cluster failed") %(str(row[0]),str(row[1]),str(row[2]))
		sys.exit(0)

def add_node(nova,INSTANCE_NAME,strCloudInit):
    print ("Launching %s") %(str(INSTANCE_NAME))
    instance_id,instance_name,instance_ip = launch_instance(nova,INSTANCE_NAME,strCloudInit)
    update_db(instance_id,instance_name,instance_ip)
    copyfile("/etc/hosts",CLUSTER_OPT+"/etc/hosts")
    config_clustersh()

def extend(addNodeCount):
    print ("Reading Config File (%s)...") %(CLUSTER_CFG)
    parse_conf(CLUSTER_CFG)
    print ("Extending the cluster by adding %s nodes") %(addNodeCount)
    strKey="Are you sure?"
    ret = query_yes_no(strKey, "no")
    if ret == False:
	sys.exit(0)
	
    creds = get_nova_creds()
    nova = nvclient.Client(**creds)
    verify_cluster(nova)
    nextNode=int(next_node(INSTANCE_NAME))
    #print nextNode
    strCloudInit=compute_cloud_init()
    for iCount in xrange(addNodeCount):
	nextNode = int(nextNode) + 1
	print "Node %s being added to the cluster..." %(INSTANCE_NAME+str(nextNode))
        add_node(nova,INSTANCE_NAME+str(nextNode),strCloudInit)
    print ("Compute nodes added to the cluster.. \nPlease run './readyCluster.py -s' to restart services on the entire cluster or individually start services using './readyCluster.py -n NODE' and restart slurm on the headnode.")		
	
def shrink(nodeCount):
    print ("Reading Config File (%s)...") %(CLUSTER_CFG)
    parse_conf(CLUSTER_CFG)
    print ("This operation will delete %s nodes") %(nodeCount)
    strKey="Are you sure?"
    ret = query_yes_no(strKey, "no")
    if ret == False:
        sys.exit(0)

    creds = get_nova_creds()
    nova = nvclient.Client(**creds)
    verify_cluster(nova)
    nextNode=int(next_node(INSTANCE_NAME))
    db = CLUSTER_NAME + ".db"
    conn = sqlite3.connect(db)
    for iCount in xrange(nodeCount):
	sSQL="Select * from nodes where name = '%s'" %(INSTANCE_NAME+str(nextNode))
	ret=conn.execute(sSQL)
	#print ret
	#print nextNode
	for server in ret:
	    print "Terminating instance %s (id: %s) " %(server[1],server[0])
	    try:
                    ret = nova.servers.delete(str(server[0]))
            except:
                    print "Error terminating the instance..."
                    e = sys.exc_info()[1]
                    print "Error: %s " % e
                    sys.exit(0)
            try:
                    print str(server[2])
                    remove_line("/etc/sysconfig/iptables",str(server[2]))
		    fileSystems=['/apps','/home', '/opt','/system','/short']
		    toRemove=server[2] + "(rw,sync)"
		    for fs in fileSystems:
                  	  replace_string_line("/etc/exports",toRemove)
		    remove_line("/etc/hosts",str(server[2]))
            except:
                    print "Error removing the iptables or nfs exports entry for %s... please remove manually" %(str(server[2]))
                    e = sys.exc_info()[1]
                    print "Error: %s " % e
	    remove_node_db(INSTANCE_NAME+str(nextNode))
	    nextNode = nextNode - 1
    conn.close()	   	
    proc = subprocess.Popen(["service", "nfs", "restart"], stdout=subprocess.PIPE, shell=False)
    proc.wait()

def build():	
	print ("Reading Config File (%s)...") %(CLUSTER_CFG)
	parse_conf(CLUSTER_CFG)
	print ("Initializing Cloud (%s)...") %(CLUSTER_NAME)
	create_cluster_db()
	creds = get_nova_creds()
	nova = nvclient.Client(**creds)
	check_keypair(nova)
	create_secgroup(nova)
	headnode_secgroup(nova)
	check_munge()
	setup_slurmhead()
	create_hosts_file()
	prep_nfs_exports()
	print ("Launching total of %s Compute Nodes...\n") %(str(CLUSTER_COMPUTE_SIZE))
	strCloudInit=compute_cloud_init()
	for iCount in range(CLUSTER_RANGE_START,CLUSTER_COMPUTE_SIZE+1):
		print ("Launching %s") %(str(INSTANCE_NAME + str(iCount)))
		instance_id,instance_name,instance_ip = launch_instance(nova,INSTANCE_NAME+str(iCount),strCloudInit)
		update_db(instance_id, instance_name,instance_ip)
		#We copy the hosts file and configure clustersh. This ensures that in case of a failure to
		#launch a compute node,  user still gets a working cluster. E.g. you requested 10 nodes
		#but only got 8 due to capacity or quota issues.
		copyfile("/etc/hosts",CLUSTER_OPT+"/etc/hosts")
		config_clustersh()

	copyfile("/etc/hosts",CLUSTER_OPT+"/etc/hosts")	
	#Not dealing with volumes automatically. Let user decide what is best.
	#c_creds = get_cinder_creds()
	#c_conn = ciclient.Client(**c_creds)
	#cinder_volume_create(c_conn)
        #print(c_conn.volumes.list())
	config_clustersh()
	print ("Cluster launched.... please wait for sometime and then run readyCluster -s to start the daemons\n")
	sys.exit(0) 

def main():
	parser = optparse.OptionParser()
	parser.add_option('-c', '--config', dest='config', default='cluster.cfg' , help='Use different configuration file (default: cluster.cfg)')
	parser.add_option('-b', '--build', action="store_true", default=False , help='Builds a new cluster from cluster.cfg file')
	parser.add_option('-d', '--destroy', action="store_true", default=False , help='Destroys the cluster from cluster.cfg file')
	parser.add_option('-e', '--extend', action="store", default=0, type="int" , help='Adds a node to the cluster')
	parser.add_option('-s', '--shrink', action="store", default=0, type="int" , help='Terminate nodes')
	(opts, args) = parser.parse_args()
	global CLUSTER_CFG
	#print opts
	#print args
        if not opts.build and not opts.destroy and not opts.extend and not opts.shrink:
            parser.print_help()
            sys.exit(0)
	if (opts.build and opts.destroy) or  (opts.extend and opts.destroy) or (opts.extend and opts.build):
		print "Options -b, -d, -e are mutually exclusive"
		sys.exit(0)
	if opts.config is not None:
		CLUSTER_CFG=str(opts.config)
	if opts.build == True:
        	build()
	elif opts.destroy == True:
		destroy()
        elif opts.extend > 0:
		#print opts.extend
                extend(opts.extend)
	elif opts.shrink > 0:
		shrink(opts.shrink)
	else:
		parser.print_help()
            	sys.exit(0)
if __name__ == '__main__':
    main()
