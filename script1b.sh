#!/bin/bash

input="file.in"

while IFS= read -r line
do  
	(
    [[ "$line" == \#* ]] && continue
    line2="${line//\//\\}"
	if wget -q "$line" -O "new$line2.html" > /dev/null; then
		if [ -f "$line2.html" ]; then
			cmp --silent "$line2".html "new$line2.html" || echo "$line"
		else    
			echo "$line INIT" 
		fi          
        else
            echo "$line FAIL"
        fi  
        mv "new$line2.html" "$line2".html
	) & 
done <"$input"
wait
