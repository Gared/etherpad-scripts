etherpad-scripts
================

Several scripts for managing etherpad(-lite) server.
These scripts only work on bash shells with mysql database as backend for etherpad(-lite).

Attention: Run these scripts only when etherpad(-lite) has been stopped. Most of these scripts will change/delete data from your database so please be patient when using these scripts. This can't be undone.

## Bash scripts
### for etherpad
* delete_pad.sh \<padId\> \[domainId\] (Deletes a public or team pad from database)
* delete_team.sh \<team/subdomain\> (Deletes a whole team. Calls delete_pad.sh)
* export_pad.sh \<padId\> \[domainId\] (Extract the pad data to your file system using "mysqldump". You can use it to archive pads and import them if needed. See import_sql.sh for importing them again.)
* export_team.sh \<team/subdomain\> (Extract the whole team with all pads. Calls export_pad.sh)
* import_sql.sh \<pathToDirectoryOfTeamOrPad\> (Imports an exported team or pad into database again)
* stats.sh (Statistics about your etherpad instance)

### for etherpad_lite
* stats.sh (Statistics about your etherpad lite instance)

#### Variables
- domainId: Id of the domain of the team (ID in the table pro_domains in the database)
- padId: Id of the pad (e.g. team.example.com/**myPadId**)
- team/subdomain: Name of the team (e.g. **team**.example.com)

## How to use
* git clone https://github.com/Gared/etherpad-scripts.git
* cd etherpad-scripts/etherpad
* Edit the configuration section of the script you want to run
* Call a script for example: ./export_pad.sh test 23