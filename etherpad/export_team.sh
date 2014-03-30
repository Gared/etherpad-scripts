#!/bin/bash

# Export whole team (team configuration and pads)

# ----- Configuration -----

host=""
user="etherpad"
database="etherpad"
password=""
exportFolder="teams"
charSet=utf8

# ----- Do not edit the following code -----

path="$exportFolder/$1"
teamname=$1

if [ "$1" == "" ]; then
        echo "$0 <team/subdomain>"
        exit
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

echo "----- $teamname -----"
echo "checkPathExists..."
checkPathExists "$path"

echo "Team: $teamname"
echo "Create path: $path"
mkdir -p $path

path=$path"/"

# Get domainId of team
domainid=`mysql -h $host -u $user -p$password -s -N -e "SELECT ID FROM pro_domains WHERE subDomain = '$teamname'" $database`

# export PRO_DOMAINS
echo "Exporting PRO_DOMAINS..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database pro_domains --where="id='$domainid'" | grep "INSERT INTO" > "$(echo $path)PRO_DOMAINS.sql"

echo "Exporting PRO_ACCOUNT_USAGE..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database pro_account_usage --where="domainId='$domainid'" | grep "INSERT INTO" > "$(echo $path)PRO_ACCOUNT_USAGE.sql"

echo "Exporting PRO_ACCOUNTS..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database pro_accounts --where="domainId='$domainid'" | grep "INSERT INTO" > "$(echo $path)PRO_ACCOUNTS.sql"

echo "Exporting PRO_CONFIG..."
mysqldump -h $host -u $user -p$password --default-character-set=$charSet $database pro_config --where="domainId='$domainid'" | grep "INSERT INTO" > "$(echo $path)PRO_CONFIG.sql"

echo "Export pads of team..."
padids=`mysql -h $host -u $user -p$password -s -N -e "SELECT localPadId FROM pro_padmeta WHERE domainId = '$domainid'" $database`

for padid in $padids
do
	./export_pad.sh $padid $domainid
done

