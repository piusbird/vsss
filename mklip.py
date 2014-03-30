#!/usr/bin/env python
# Minimal KDE Klipper service emulator
# For GNOME, XFCE, LXDE and MATE
# Part of the Very Shitty Speech Setup

"""
Copyright (c) 2014 Matt Arnold
# 
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose with or without fee is hereby granted, 
# provided that the above copyright 
# notice and this permission notice appear in all copies.
# AND WITH THE STIPULATION THAT

# By distributing this software, you waive any legal power to 
# forbid circumvention of technological measures 
# to the extent such circumvention is effected by exercising rights under 
# this License with respect to the covered work, 
# and you disclaim any intention to limit operation or 
# modification of the work as a means of enforcing, 
# against the work's users, your or third parties' 
# legal rights to forbid circumvention of technological measures.

# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES 
# OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR 
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES 
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, 
# DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, 
# NEGLIGENCE OR OTHER TORTIOUS ACTION, 
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE

"""

from gi.repository import Gtk, Gdk
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
import os, sys
import signal
import fileinput
import re

class NullDevice:
    def write(self, s):
            pass

def hup_handle(sig, fr):
    sys.exit()

class MiniKlipper(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('org.marnold.mklip', bus=dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/org/marnold/mklip')
        self.boardxs =  Gtk.Clipboard.get(Gdk.SELECTION_CLIPBOARD)
    
    @dbus.service.method('org.marnold.mklip')
    def getClipboardContents(self):
        
        text = self.boardxs.wait_for_text()
        if text == None:
            return "Nothing to read"
        return text
    
    @dbus.service.method('org.marnold.mklip')
    def getPid(self):
        
        pidstr = str(os.getpid())
        return pidstr
	
	@dbus.service.method('org.marnold.mklip')
	
	def getFilteredContent(self, stSrc, stEnd):
		
		retStr = ""
		
		for line in fileinput.input():
			line = re.sub(stSrc, stEnd, line.rstrip())
			retStr += line
		
		return retStr    
        
pid = os.fork() ## Hmmm this looks an awful lot like... C

if pid:
        os._exit(0) # kill the parent
else:
        ## directions say this will stop exceptions while
        ## deamonized. Which would be bad
        os.setpgrp()
        os.umask(0)
        
        print os.getpid() # to aid in stoping the server
        # Run silent, run deep
        sys.stdin.close() 
        sys.stdout = NullDevice()
        sys.stderr = NullDevice()

signal.signal(signal.SIGHUP, hup_handle)
signal.signal(signal.SIGTERM, hup_handle)
DBusGMainLoop(set_as_default=True)
myservice = MiniKlipper()
Gtk.main() 
