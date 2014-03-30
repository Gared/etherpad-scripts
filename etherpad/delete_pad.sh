#!/bin/bash

# This script deletes a public or team pad from database
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
user="root"
database="etherpad"
password=""
charSet=utf8

# ----- Do not edit the following code -----

domainid=$1
isTeampad=0

if [ "$1" == "" ]; then
        echo "$0 <padId> [domainId]"
        exit
fi
if [ "$2" != "" ]; then
        isTeampad=1
        domainid=$(echo $2)"$"$(echo $domainid)
fi

echo "PadId: $domainid"
if [ $isTeampad = 1 ]; then
        echo "Deleting PRO_PADMETA..."
        mysql -h $host -u $user -p$password -e "DELETE FROM pro_padmeta where domainId='$2' and localPadId='$1'" $database
fi

echo "Deleting PAD_META and PAD_APOOL..."
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_APOOL where ID='$domainid'" $database

echo "Deleting PAD_AUTHORS_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_AUTHORS_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_AUTHORS_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_AUTHORS_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_CHAT_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_CHAT_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_CHAT_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_CHAT_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_REVMETA_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVMETA_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVMETA_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVMETA_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_REVS_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_REVS10_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS10_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS10_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS10_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_REVS100_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS100_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS100_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS100_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_REVS1000_*..."
numid=`mysql -h $host -u $user -p$password -s -N -e "SELECT NUMID FROM PAD_REVS1000_META WHERE ID = '$domainid'" $database`
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS1000_META where ID='$domainid'" $database
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_REVS1000_TEXT where NUMID='$numid'" $database

echo "Deleting PAD_SQLMETA..."
mysql -h $host -u $user -p$password -e "DELETE FROM PAD_SQLMETA where ID='$domainid'" $database

echo "----- Deletion finished: $domainid -----"
