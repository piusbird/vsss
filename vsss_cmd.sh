#!/bin/bash

## Moduule vsss_cmd.sh
## Purpose: Command interpitor for very stupid speech shell
## Author: Matt Arnold <mattarnold5@gmail.com>
## Start Date: 12/20/2013
## Modified: 2/15/2014

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
mkfil() {
    
    cd $BASEDIR
    cat <<STP > $BASEDIR/filter.sh
      #!/bin/bash
      set -e
      
      sed -i 's:-:fixme::g' active
STP
   
    pluma $BASEDIR/filter.sh
    chmod +x filter.sh
}

clr() {
	rm -f $BASEDIR/*
}

snarf() {
	if test -n "$OURFILE" -a -s "$OURFILE"
	then
		ln -sf $OURFILE  $BASEDIR/last
	fi
	OURFILE=`mktemp --tmpdir=$BASEDIR`
	ln -sf $OURFILE $BASEDIR/active
	$SNARF_CMD > $OURFILE
	cat $OURFILE

}

lexerr() {
	echo "Invalid Token"
}
echo "Very Stupid Speech Shell"
echo "Version 0.2"
while $WATCH
do
	echo 
	echo
	echo -n ':'
	read cmd
	
case "$cmd" in
        ss|s)
            snarf
	    padsp swift -m text -f $BASEDIR/active  
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
	padsp swift -m text -f $BASEDIR/active
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
	
	f)
            if ! [  -a $BASEDIR/filter.sh ]; then
            
                mkfil
            
            fi
        cd $BASEDIR
        pwd
        ./filter.sh
        cd $work
        ;;
        
        ef)
        if ! [  -a $BASEDIR/filter.sh ]; then
            
                mkfil
            
            fi
        pluma $BASEDIR/filter.sh
        ;;
        *)
            lexerr
 
esac
done
