#!/bin/bash

# This script exports a public or team pad from database to *.sql files
# Tables
#
# Only pro pads: PRO_PADMETA
#
# PAD_META
# PAD_APOOL
# PAD_AUTHORS_META
# PAD_AUTHORS_TEXT
# PAD_CHAT_META
# PAD_CHAT_TEXT
# PAD_REVMETA_META
# PAD_REVMETA_TEXT
# PAD_REVS_META
# PAD_REVS_TEXT
# PAD_REVS10_META
# PAD_REVS10_TEXT
# PAD_REVS100_META
# PAD_REVS100_TEXT
# PAD_REVS1000_META
# PAD_REVS1000_TEXT
# PAD_SQLMETA

# ----- Configuration -----

host=""
user="etherpad"
database="etherpad"
password=""
exportFolder="public"
charSet=utf8

# ----- Do not edit the the following code -----

path="$exportFolder/$1"
domainid=$1
isTeampad=0

if [ "$1" == "" ]; then
	echo "$0 <padId> [domainId]"
	exit
fi
if [ "$2" != "" ]; then
	isTeampad=1
	path="teampads/$2/$1/"
	domainid=$(echo $2)"$"$(echo $domainid)
fi

function checkPathExists {
	dirCounter=$2
	echo "dir counter: $dirCounter"
	if [ "$2" == "" ]; then
		dirCounter=0
		dirSuffix=""
	else
		dirSuffix="_$2"
	fi
	if [ -d "$1$dirSuffix" ]; then
		let dirCounter+=1
		checkPathExists "$1" "$dirCounter"
	else
		path="$1$dirSuffix"
	fi
}

echo "----- $domainid -----"
echo "checkPathExists..."
checkPathExists "$path"

echo "PadId: $domainid"
echo "Create path: $path"
mkdir -p $path

path=$path"/"

if [ $isTeampad = 1 ]; then
	echo "Exporting PRO_PADMETA..."
	mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database pro_padmeta --where="domainId='$2' and localPadId='$1'" | grep "INSERT INTO" > "$(echo $path)PRO_PADMETA.sql"
fi

echo "Exporting PAD_META and PAD_APOOL..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_META.sql"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_APOOL --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_APOOL.sql"

echo "Exporting PAD_AUTHORS_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_AUTHORS_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_AUTHORS_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_AUTHORS_META WHERE ID = '$domainid'" $database`
echo "PAD_AUTHORS_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_AUTHORS_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_AUTHORS_TEXT.sql"

echo "Exporting PAD_CHAT_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_CHAT_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_CHAT_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_CHAT_META WHERE ID = '$domainid'" $database`
echo "PAD_CHAT_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_CHAT_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_CHAT_TEXT.sql"

echo "Exporting PAD_REVMETA_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVMETA_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVMETA_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVMETA_META WHERE ID = '$domainid'" $database`
echo "PAD_REVMETA_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVMETA_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVMETA_TEXT.sql"

echo "Exporting PAD_REVS_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS_META WHERE ID = '$domainid'" $database`
echo "PAD_REVS_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS_TEXT.sql"

echo "Exporting PAD_REVS10_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS10_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS10_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS10_META WHERE ID = '$domainid'" $database`
echo "PAD_REVS10_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS10_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS10_TEXT.sql"

echo "Exporting PAD_REVS100_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS100_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS100_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS100_META WHERE ID = '$domainid'" $database`
echo "PAD_REVS100_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS100_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS100_TEXT.sql"

echo "Exporting PAD_REVS1000_*..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS1000_META --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS1000_META.sql"
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS1000_META WHERE ID = '$domainid'" $database`
echo "PAD_REVS1000_META NUMID: $numid"
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_REVS1000_TEXT --where="NUMID='$numid'" | grep "INSERT INTO" > "$(echo $path)PAD_REVS1000_TEXT.sql"

echo "Exporting PAD_SQLMETA..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database PAD_SQLMETA --where="ID='$domainid'" | grep "INSERT INTO" > "$(echo $path)PAD_SQLMETA.sql"

echo "Exports finished"
echo "Writing export meta information..."
# write dump meta informations
echo "Export time: $(date)" > "$(echo $path)export_meta.txt"

echo "----- Export finished: $domainid -----"

