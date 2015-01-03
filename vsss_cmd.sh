#!/bin/bash

## Moduule vsss_cmd.sh
## Purpose: Command interpitor for very stupid speech shell
## Author: Matt Arnold <mattarnold5@gmail.com>
## Start Date: 12/20/2013
## Modified: 2/15/2014
source vsss_funclib.sh
VOX="Duncan"
audio_bckend="padsp"
##  We Require Plan 9 from User Space to make this work 
##  so insstall it, and adjust these vars accordingly
##  I've put in a resonable defualt 
PLAN9=/usr/local/plan9 export PLAN9
PATH=$PATH:$PLAN9/bin export PATH

# SNARF_CMD  gets the curreng clipboard contents
# Ways of doing this will very depending on desktop env/window managers

SNARF_CMD="qdbus org.marnold.mklip /org/marnold/mklip getClipboardContents"


OURFILE=""
WATCH=`true`
BASEDIR="$HOME/.vsss"
SESSIONDIR="$BASEDIR/session"
mkdir -p $BASEDIR
mkdir -p $SESSIONDIR
clr() {
	rm -f $SESSIONDIR/*
}

snarf() {
	if test -n "$OURFILE" -a -s "$OURFILE"
	then
		ln -sf $OURFILE  $SESSIONDIR/last
	fi
	ndp=`what_name`
	OURFILE=`kytemp $SESSIONDIR $ndp `
	ln -sf $OURFILE $SESSIONDIR/active
	$SNARF_CMD > $OURFILE
	cat $OURFILE | nobs

}

act_man() {
    
        if test -n "$OURFILE" -a -s "$OURFILE"
        then
                ln -sf $OURFILE  $SESSIONDIR/last
        fi
	ndp=`what_name`
        OURFILE=`kytemp $SESSIONDIR $ndp`
        ln -sf $OURFILE $SESSIONDIR/active
}
lexerr() {
	echo "Invalid Token"
}
echo "Very Stupid Speech Shell"
echo "Version 0.2.4"
while $WATCH
do
	echo 
	echo
	echo -n '>>'
	read cmd
	
case "$cmd" in
        ss|s)
            snarf
	    $audio_bckend swift -n $VOX -m text -f $SESSIONDIR/active  

            ;;
         
        m)
	    work=`pwd`
            cd $BASEDIR
	    env sh
	    cd $work
            ;;
         
        c)
	cat $SESSIONDIR/active > $SESSIONDIR/last
	cat /dev/null > $SESSIONDIR/active
	;;
	
	sc)
	clear
	;;
	e)
	echo $OURFILE
	pluma $SESSIONDIR/active
	;;
	q|Q)
	clr
	exit 0
	;;
	r)
	cat $OURFILE
	$audio_bckend swift -n $VOX -m text -f $OURFILE
	;;
	l)
	snarf
	;;
	b)
	cat $SESSIONDIR/last > $SESSIONDIR/active
	echo "Head Reset to previous"
	;;

	n)
	clr
	echo "Session History Cleared"
	;;
	ap)
	qdbus org.marnold.mklip /org/marnold/mklip amalgmateClipboard
	echo "Action $cmd Done"
	;;
	as)
        act_man
        qdbus org.marnold.mklip /org/marnold/mklip getAmalgamatedBuffer > $SESSIONDIR/active
        cat $SESSIONDIR/active
        aoss swift -m text -f $SESSIONDIR/active
        ;;
        ac)
        qdbus org.marnold.mklip /org/marnold/mklip clearAmalgamatedBuffer
        echo "Text Buffer Cleared"
        ;;
        *)
            lexerr
 
esac
done

