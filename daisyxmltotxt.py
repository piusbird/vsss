#!/usr/bin/env python
# daisyxmtotxt.py: Extract content from DAISY XML
# Dump to Unicode text file
# (C) Matt Arnold 2015
# Premission to use this code is given under the
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
# See http://www.wtfpl.net/about/


from sys import argv, exit
import re
import textwrap
import BeautifulSoup 
from StringIO import StringIO

junk_tags = ['style', 'script', '[document]', 'head', 'title']
def isjunk(element):
    if element.parent.name in junk_tags:
        return False
    elif re.match('<!--.*-->', str(element)):
        return False
    return True


if len(argv) < 3:
    
    print "Usage: <input.xml> <output.txt>"
    exit(1)
outw = 80
if len(argv) == 4 and  argv[3].isdigit():
    outw = int(argv[3])
    
fp = open(argv[1])
unparsed = fp.read()
fp.close()
soup = BeautifulSoup.BeautifulSoup(unparsed)

utext = soup.findAll(text=True)
ctext = filter(isjunk, utext)
buffer = StringIO()

for t in ctext:

    buffer.write(t.encode('utf-8'))





mt = textwrap.dedent(buffer.getvalue()).strip()
ftm = textwrap.fill(mt, width=outw)

op = open(argv[2], 'w+')
op.write(ftm)
op.close()
exit(0)
