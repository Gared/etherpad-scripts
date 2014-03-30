#!/bin/bash

# ----- Configuration -----

host=""
user="etherpad"
database="etherpad"
password=""

# ----- Do not edit the following code -----

countAllOldPads=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_META;" $database)
countAllOldTeamPads=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_META where ID LIKE '%$%';" $database)
countAllOldPublicPads=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_META where ID NOT LIKE '%$%';" $database)
countAllProAccounts=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from pro_accounts;" $database)
countAllUniqueProAccounts=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from (select distinct email from pro_accounts) test;" $database)
countAllProDomains=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from pro_domains;" $database)

dbSize=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select round(sum(data_length+index_length)/1024/1024/1024,4) from information_schema.tables where table_schema='$database'" $database)

countPadsEditedLastDay=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_SQLMETA where lastWriteTime > (curdate() - INTERVAL 1 DAY)" $database)
countPadsEditedLastWeek=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_SQLMETA where lastWriteTime > (curdate() - INTERVAL 1 WEEK)" $database)
countPadsEditedLastMonth=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_SQLMETA where lastWriteTime > (curdate() - INTERVAL 1 MONTH)" $database)
countPadsEditedLastYear=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_SQLMETA where lastWriteTime > (curdate() - INTERVAL 365 DAY)" $database)
countPadsEditedOlderYear=$(mysql -h $host -u $user --skip-column-names -p$password -B -e "select count(*) from PAD_SQLMETA where lastWriteTime < (curdate() - INTERVAL 365 DAY)" $database)

countDeletedPads=$("select count(*) from pro_padmeta where isDeleted=1" $database)

echo "Pads: $countAllOldTeamPads (Team-Pads: $countAllOldTeamPads, Public Pads: $countAllOldPublicPads)"
echo "DB size: $dbSize GB"
echo "Pro-accounts: $countAllProAccounts (Unique: $countAllUniqueProAccounts)"
echo "Pro-Domains: $countAllProDomains"
echo "Edited last 24 hours: $countPadsEditedLastDay"
echo "Edited last week: $countPadsEditedLastWeek"
echo "Edited last month: $countPadsEditedLastMonth"
echo "Edited last year: $countPadsEditedLastYear"
echo "Edited last rest: $countPadsEditedOlderYear"
echo "Deleted pads: $countDeletedPads"

