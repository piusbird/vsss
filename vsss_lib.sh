#!/bin/bash     

# Support funtions for vsss

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

# Function to output progress bar data for dialog/whiptail 
# Lifted from http://pseudoscripter.wordpress.com/2012/09/26/whiptail-using-a-progress-gauge/
# Slight modification for functional use 
progbar_data() {

        i="0"
        while (true)
        do
            proc=$(ps aux | grep -v grep | grep -e "$1")
            if [[ "$proc" == "" ]]; then break; fi
            sleep 1
            echo $i
            i=$(expr $i + 1)
        done
        # If it is done then display 100%
        echo 100
        # Give it some time to display the progress to the user.
        sleep 2
} 


widget_prog() {
     whiptail --title "$1" --gauge "$2" 8 78 0
}
