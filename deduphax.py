#!/usr/bin/python2

import os
import time 
import hashlib
from sys import argv

olddir = os.getcwd()
os.chdir(argv[1])

for onm in os.listdir("."):
	nnm = ""
	ts = os.stat(onm)[-1]
	datestmp = time.strftime("%m-%d-%Y", time.localtime(ts))
	fp = open(onm)
	buf = fp.read(1024)
	h = hashlib.sha384(buf).hexdigest()
	nnm = datestmp + '-' + h[0:15]
	os.rename(onm,nnm)

os.chdir(olddir)
