# Common functions for vsss
# Matt Arnold (C) 2014

## kytemp replace mktemp with something 
##  Cross platform with features to aid
## Speech sesseion search
kytemp() {

	if [ "$#" -ne 2 ]
	then 
		echo "Illegal number of argument"
		return 1
	fi

	nounce=`cat /dev/urandom | tr  -dc [a-zA-Z0-9] | fold -b8 | head -1`
	filename=$(echo $2.$nounce)
	touch $1/$filename
	echo "$1/$filename"  | tr -s '/'
}

## what_name determines what key name to give to temp files 
# Use with kytemp
# This function uses two env variables to deterimeine what
# Descriptive name to give temp files
# CKY beats TAG format of filenames is $(echo whatname).$nounce
###
what_name() {

	if [ -n "$CKY" ]
	then
		echo $CKY
		return 
	elif [ -n "$TAG" ]
	then
		echo $(date +"%m-%d-%Y").$TAG
		return 
	fi
	
	echo $(date +"%m-%d-%Y").$$
}

# find_shell_config does what it says
# i.e find the location of the file containing configuration
# info for shell
find_shell_config() {

  if [ -s $1/vsss.conf.in ]
  then
	echo $1/vsss.conf.in | tr -s '/'
  elif [ -s ./vsss.conf.in ]
  then
	echo "./vsss.conf.in"
  else
	return 1
fi
}
