#!/bin/bash

# This script deletes a whole team from database

# ----- Configuration ------

host=""
user="root"
database="etherpad"
password=""
exportFolder="public"

# ----- Do not edit the following code ------

path="$exportFolder/$1"
teamname=$1

if [ "$1" == "" ]; then
        echo "$0 <team/subdomain>"
        exit
fi

echo "PadId: $domainid"

# Get domainId of team
domainid=`mysql -h $host -u $user -p$password -s -N -e "SELECT ID FROM pro_domains WHERE subDomain = '$teamname'" $database`

echo "Delete pads of team..."
# Get all padids of this team
padids=`mysql -h $host -u $user -p$password -s -N -e "SELECT localPadId FROM pro_padmeta WHERE domainId = '$domainid'" $database`

for padid in $padids
do
        ./delete_pad.sh $padid $domainid
done

echo "Deleting PRO_DOMAINS..."
mysql -h $host -u $user -p$password -e "DELETE FROM pro_domains where id='$domainid'" $database

echo "Deleting PRO_ACCOUNT_USAGE..."
mysql -h $host -u $user -p$password -e "DELETE FROM pro_account_usage where domainId='$domainid'" $database

echo "Deleting PRO_ACCOUNTS..."
mysql -h $host -u $user -p$password -e "DELETE FROM pro_accounts where domainId='$domainid'" $database

echo "Deleting PRO_CONFIG..."
mysql -h $host -u $user -p$password -e "DELETE FROM pro_config where domainId='$domainid'" $database

echo "----- Deletion finished: $teamname -----"
