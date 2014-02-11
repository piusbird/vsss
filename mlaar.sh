#!/bin/bash

## WaRNING M. Arnold Logicstics INTERNAL CODE 
## AHEAD 

## Writen for venomoth.internal use outside is not advised
## PATHS ARE HARD CODED FUDGE YOU
## But this is ISC licensed so if it ever does make it off 
## an internal server
## You can have fun with it


set -e # bah error checking who wants that
echo "M. Arnold Logicistics Audiobook renderer"
echo "This is a shittastic hax"
echo "To get off of Windows 2000 ActiveX stuff"
echo "Fix Me!"
echo "This annoying log message brought to you by"
echo "The Letter F and the Number 0x75"
rm -f /srv/audiorender/current/*
JOBID=`cat /dev/urandom | tr -dc '0-9' | fold  -w 5 | head -1`

# We want jobid to be random because we lack state
#

CHUNKSIZE=10240 # 10K
cp $1 /srv/audiorender/current/src.txt
cd /srv/audiorender/current
echo "$(date -R) Start Job $JOBID" >> /srv/audiorender/jdone/jobcomp.log
pwd
echo $JOBID > ../thisjob
split -b $CHUNKSIZE src.txt  doc.$JOBID

for dcs in $(ls doc.*) 
do
   echo "Rendering Chunk $dcs"
   swift -m text -f $dcs -o $dcs.wav
done

NC=0
for wv in $(ls *.wav)
do
	echo "Encoding $wv"
	NC=$(($NC + 1))
	lame -v -V 2 -b 16 $wv "MALAR_$JOBID_$NC.mp3"

done

ls *.mp3 > "MALAR_$JOBID.m3u"

zip -r "MALAR_$JOBID.zip" $(ls *.mp3 *.m3u)
cp *.zip /srv/audiorender/jdone/
echo "$(date -R) Finished Job $JOBID" >> /srv/audiorender/jobcomp.log
rm *
cd

