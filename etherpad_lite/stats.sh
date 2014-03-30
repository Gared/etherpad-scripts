#!/bin/bash

# ----- Configuration -----

host=""
user="etherpad"
database="etherpad"
password=""

# ----- Do not edit the following code -----

countAllLitePads=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from store where store.key like 'pad:%' and store.key not like 'pad:%:%';;" $database)

dbSize=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select round(sum(data_length+index_length)/1024/1024/1024,4) from information_schema.tables where table_schema='$database'" $database)

echo "EP-Lite Pads: $countAllLitePads"
echo "DB size: $dbSize GB"