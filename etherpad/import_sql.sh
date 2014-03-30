#!/bin/bash

# ----- Configuration -----

host=""
user="root"
database="etherpad"
password=""
charSet=utf8

# ----- Do not edit the following code -----

path=$1

# check if path exists

echo "Start import for path $path"
#TODO Change this to find all sql-files in all subdirectories
for f in $path/**/*.sql
do
	echo "Import file: $f"
	mysql -h $host -u $user -p$password --default-character-set=$charSet $database < $f
done

echo "---- done -----"
