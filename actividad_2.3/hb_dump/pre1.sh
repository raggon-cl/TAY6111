#!/bin/bash
# config:
# when running on debian we can use existing debian-sys-maint account using defaults file
# otherwise, specify username and password below using use_credentials

### TELEGRAM CONFIGS ###
ID="10793105"
TOKEN="1440132496:AAHOI44f7PZNgZAWnxCQpG4jQWRrClljJJ8"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
### END TELEGRAM CONFIGS ###

use_credentials="-u root -pDuoc.2021"
#defaults_file="/etc/my.cnf"
dump_file="/tmp/mysql_dump.sql"
database="--all-databases"

curl -s -X POST $URL \
  	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
	-d chat_id=$ID \
       	-d text=$'\U0001F514'" - Inicia el proceso de Respaldo de Mysql con Dump del Motor" > /dev/null 2>&1

if [[ -n "$use_credentials" ]]; then
  opts="$use_credentials"
  curl -s -X POST $URL \
  	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
	-d chat_id=$ID \
       	-d text=$'\U0001F514'" - Usa las Credenciales de Root" > /dev/null 2>&1
else
  echo "$0 : error, no mysql authentication method set" | logger
  curl -s -X POST $URL \
  	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
	-d chat_id=$ID \
       	-d text=$'\U0001F514'" - Error... Metodo de Autenticacion no Activado" > /dev/null 2>&1
  exit 1
fi

opts="$opts $database"

echo "$0 executing mysqldump" | logger
mysqldump $opts >$dump_file 2>/dev/null
if [ $? -ne 0 ]; then
  echo "$0 : mysqldump failed" | logger
  curl -s -X POST $URL \
  	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
	-d chat_id=$ID \
       	-d text=$'"\U0001F514'" - Error... MySQL Dump Fallo" > /dev/null 2>&1
  exit 2
else
  echo "$0 : mysqldump suceeded" | logger
  curl -s -X POST $URL \
  	-H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \
	-d chat_id=$ID \
       	-d text=$'\U0001F514'" - Exito... MySQL Dump Correcto $dump_file" > /dev/null 2>&1
  sync
  sync
fi
