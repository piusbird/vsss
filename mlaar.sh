#!/bin/bash

# Copyright (c) 2014 Matt Arnold
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

if [ $# -lt 2 ]; then
    echo Usage: $0 "<job-descriptor> <filename>"
    exit 1
fi
set -e # bah error checking who wants that


source mlaar.conf.in
source vsss_lib.sh
if [ -a $QUEUEDIR/tip ]; then
    
    JOBID=`cat $QUEUEDIR/tip`
    JOBID=$(($JOBID + 1))
fi
## Actual Code starts here

# make the proper dirs if do not exist
mkdir -p $JOBDIR
mkdir -p $JOBDIR/last
mkdir -p $QUEUEDIR
mkdir -p $QUEUEDIR/done
mkdir -p $ATTICDIR
mv $JOBDIR/* $ATTICDIR

echo "M. Arnold Logicistics Audiobook renderer"
echo "Lord have Mercy"
echo "Christ Have Mercy"
echo "Lord we beseech the"
echo "Grant us O King of the Universe"
echo "That through the intercession of Saint Thomas Aquinus"
echo "This humble hax may have sublime flow and logical consistancy"
echo "Protect o Sprit the feble senses of the user"
echo "So that he does not through his inevitible error"
echo "Cause the machine to become b0rked"
echo "Amen"
echo "(;" 

cp $2 $JOBDIR/src.txt
cd $JOBDIR
echo "$(date -R) Start Job $JOBID" 
pwd
echo $JOBID > $QUEUEDIR/tip
split -b $CHUNKSIZE src.txt  doc.$JOBID
(
for dcs in $(ls doc.*) 
do
   swift -m text -f $dcs -o $dcs.wav
done
) & # Oh look multi-threaded shell scripting >;)
progbar_data swift.bin | widget_prog "Rendering audio" "Book $1"

NC=0
for wv in $(ls *.wav)
do
	echo "Encoding $wv"
	# really bad way to do this
	NC=$(($NC + 1))
        jobdesc="$1_0$NC"
	lame -v -V 2 -b 16 $wv "$jobdesc.mp3"

done

ls *.mp3 | sort -t '_' -k2 -g > "MALAR_$JOBID.m3u"

zip -r "MALAR_$1.zip" $(ls *.mp3 *.m3u)
cp *.zip $QUEUEDIR/done
echo "$(date -R) Finished Job $JOBID" 
mv * $ATTICDIR
cd