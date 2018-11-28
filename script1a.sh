#!/bin/bash

input="file.in"

while IFS= read -r line
do  
	# check if input line is a comment  
	case "$line" in \#*) continue ;; esac         
	
	line2="${line//\//\\}"
	
	if wget -q "$line" -O index.html > /dev/null; then
		if [ -f "$line2.html" ]; then
			cmp --silent "$line2".html index.html || echo "$line"
		else	
			echo "$line INIT" 
		fi			
	else
		echo "$line FAIL"
	fi	
	mv index.html "$line2".html  
done <"$input"
