#!/bin/bash

## Moduule vsss_cmd.sh
## Purpose: Command interpitor for very stupid speech shell
## Author: Matt Arnold <mattarnold5@gmail.com>
## Start Date: 12/20/2013
## Modified: 2/15/2014
source vsss_funclib.sh
VOX="Duncan"
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
mkdir -p $BASEDIR
clr() {
	rm -f $BASEDIR/*
}

snarf() {
	if test -n "$OURFILE" -a -s "$OURFILE"
	then
		ln -sf $OURFILE  $BASEDIR/last
	fi
	ndp=`what_name`
	OURFILE=`kytemp $BASEDIR $ndp `
	ln -sf $OURFILE $BASEDIR/active
	$SNARF_CMD > $OURFILE
	cat $OURFILE | nobs

}

act_man() {
    
        if test -n "$OURFILE" -a -s "$OURFILE"
        then
                ln -sf $OURFILE  $BASEDIR/last
        fi
	ndp=`what_name`
        OURFILE=`kytemp $BASEDIR $ndp`
        ln -sf $OURFILE $BASEDIR/active
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
	    aoss swift -n $VOX -m text -f $BASEDIR/active  
            ;;
         
        m)
	    work=`pwd`
            cd $BASEDIR
	    env sh
	    cd $work
            ;;
         
        c)
	cat $BASEDIR/active > $BASEDIR/last
	cat /dev/null > $BASEDIR/active
	;;
	
	sc)
	clear
	;;
	e)
	echo $OURFILE
	pluma $BASEDIR/active
	;;
	q|Q)
	clr
	exit 0
	;;
	r)
	cat $OURFILE
	aoss swift -n $VOX -m text -f $BASEDIR/active
	;;
	l)
	snarf
	;;
	b)
	cat $BASEDIR/last > $BASEDIR/active
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
        qdbus org.marnold.mklip /org/marnold/mklip getAmalgamatedBuffer > $BASEDIR/active
        cat $BASEDIR/active
        aoss swift -m text -f $BASEDIR/active
        ;;
        ac)
        qdbus org.marnold.mklip /org/marnold/mklip clearAmalgamatedBuffer
        echo "Text Buffer Cleared"
        ;;
        *)
            lexerr
 
esac
done
