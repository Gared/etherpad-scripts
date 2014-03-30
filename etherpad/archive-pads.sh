#!/bin/bash

host=""
user="etherpad"
database="etherpad"
password=""

# all public pads
mysql -h $host -u $user --skip-column-names -p$password -B -e "select id from PAD_SQLMETA where lastWriteTime < (curdate() - INTERVAL 300 DAY) AND id NOT LIKE '%$%' limit 10;" etherpad | xargs -n 1 ./exportpad_dump.sh

