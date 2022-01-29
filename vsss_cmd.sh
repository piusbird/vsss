
#!/bin/bash

## Module vsss_cmd.sh
## Purpose: Command interpitor for very stupid speech shell
## Author: Matt Arnold <mattarnold5@gmail.com>
## Start Date: 12/20/2013
## Modified: 2/15/2014
.  ./vsss_funclib.sh

##  We Require Plan 9 from User Space to make this work 
##  so insstall it, and adjust these vars accordingly
##  I've put in a resonable defualt 
PLAN9=/usr/local/plan9 export PLAN9
PATH=$PATH:$PLAN9/bin export PATH

# SNARF_CMD  gets the curreng clipboard contents
# Ways of doing this will very depending on desktop env/window managers

SNARF_CMD="qdbus org.marnold.mklip /org/marnold/mklip getClipboardContents"
PSNARF_CMD="qdbus org.marnold.mklip /org/marnold/mklip autoprocClipboardContents"
VERSION="0.3.4+test"
OURFILE=""
WATCH=`true`
BASEDIR="$HOME/.vsss"
SESSIONDIR="$BASEDIR/session"
mkdir -p $BASEDIR
mkdir -p $SESSIONDIR
. `find_shell_config $BASEDIR`


clr() {
	#rm -f $SESSIONDIR/*
	xz $SESSIONDIR/*
	mkdir -p $HOME/.vsss/old/
	mv $SESSIONDIR/*.xz $HOME/.vsss/old
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
	cat $OURFILE | nl

}
psnarf() {
	if test -n "$OURFILE" -a -s "$OURFILE"
	then
		ln -sf $OURFILE  $SESSIONDIR/last
	fi
	ndp=`what_name`
	OURFILE=`kytemp $SESSIONDIR $ndp `
	ln -sf $OURFILE $SESSIONDIR/active
	dspn=`echo $ndp.d`
	DISPFILE=`kytemp $SESSIONDIR $dspn`
	$PSNARF_CMD > $OURFILE
        (cat -n $OURFILE)

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
echo "Version $VERSION"
while $WATCH
do
	echo 
	echo
	echo -n '>>>>'
	read cmd
	
case "$cmd" in
        ss|s)
            snarf
	    speak_bckend $SESSIONDIR/active  

            ;;
         
        m)
	    work=`pwd`
            cd $BASEDIR
	    env rc
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
	$spkedit $SESSIONDIR/active
	;;
	q|Q)
	
	exit 0
	;;
	r)
	cat -n $OURFILE
	speak_bckend $OURFILE
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
        speak_bckend $SESSIONDIR/active
        ;;
        ac)
        qdbus org.marnold.mklip /org/marnold/mklip clearAmalgamatedBuffer
        echo "Text Buffer Cleared"
        ;;
	i)
	let "rate = $rate + 5"
	echo "Rate is: $rate"
	;;

	k)
	let "rate = $rate - 5"
	echo "Rate is: $rate"
	;;
	fs)
	psnarf
	speak_bckend $SESSIONDIR/active  

	;;
	t)
	cat -n $SESSIONDIR/active | less
	;;
	vox)
	select vx in  /opt/swift/voices/* exit
	do 
		case $vx in
			exit)
			break
			;;
			*)
			echo `basename $vx`
			VOX=`basename $vx`
			break
			;;
		esac
	done
	;;
        j)
	act_man
	echo -n ':? '
	read jmp
	cat $SESSIONDIR/last | sed -n "$jmp,$ p" > $SESSIONDIR/active
	#cat $SESSIONDIR/active
	speak_bckend $SESSIONDIR/active
	cat $SESSIONDIR/last > $SESSIONDIR/active
	;;
	x)
		echo -n ':? '
		read EDLN
		sed -i $EDLN $SESSIONDIR/active
	;;

	*)
            lexerr
 
esac
done

