#!/bin/bash

tar_input="input.tar.gz"
#create empty directory
mkdir -p "input"
mkdir -p "assignments"
#extract the compressed file into new directory
tar -zxvf "$tar_input" -C "input" > /dev/null
#find all .txt files
find ./input -name "*.txt" > txtfiles

#find and clone all the repositories
while IFS= read -r line
do
	txt_input="$line"
	while IFS= read -r inner_line
	do  
		#ignore comments  
		[[ "$inner_line" == \#* ]] && continue
		#ignore lines that doesn't start with "https"	
		[[ "$inner_line" != https* ]] && continue
		
		git clone "$inner_line" ./assignments &> /dev/null && \
		echo "$inner_line: Cloning OK" || echo "$inner_line: Cloning FAILED"

		break
	done < "$line"
done < txtfiles

#find all the repos
find ./assignments -mindepth 1 -maxdepth 1 -type d > repos

#run through the repos
while IFS= read -r line
do
	#calculate data
	num_dir=$(find "$line" -type d -mindepth 1 | wc -l)
	num_txt=$(find "$line" -type f -name "*.txt" | wc -l)
	num_other=$(find "$line" -type f -not -name "*.txt" | wc -l)	

	#print results
	echo ${line##*/}":"	
	echo "Number of directories: $num_dir" 
	echo "Number of txt files: $num_txt"
	echo "Number of other files: $num_other"

	#check if the repo follows the desired structure
	find "$line" -name "dataA.txt" | grep -q "$line/dataA.txt" && \
	find "$line/more" -name "dataB.txt" | grep -q "$line/more/dataB.txt" && \
	find "$line/more" -name "dataC.txt" | grep -q "$line/more/dataC.txt" && \
	echo "Directory structure is OK." || echo "Directory structure is NOT OK."

done < repos

#clear temp files
rm -rf input/
rm txtfiles
rm repos
