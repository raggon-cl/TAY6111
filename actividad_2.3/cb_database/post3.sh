#!/bin/bash
timeout=30
echo "$0 : processing post-thaw backup script" | logger
if [ -f /var/run/mysqld/mysqld.pid ]; then
  mysql_pid=$(cat /var/run/mysqld/mysqld.pid) >/dev/null 2>&1
  echo "$0 : Mysql already started with PID $mysql_pid" | logger
  exit 1
fi
echo "$0 : Starting mysqld service" | logger
systemctl start mysqld.service &>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "$0 : mysqld service startup failed" | logger
  echo "$0 : please check /var/log/mysql/mysqld.log  or systemctl status mysqld.service for more details" | logger
  exit 2
fi

c=0

while [ true ]; do
  if [ $c -gt $timeout ]; then
    echo "$0 : timed out, mysql startup failed" | logger
    exit 2
  fi
  # check if mysql is running
  if [ -f /var/run/mysqld/mysqld.pid ]; then
    mysql_pid=$(cat /var/run/mysqld/mysqld.pid) >/dev/null 2>&1
    echo "$0 : MySQL started with pid $mysql_pid" | logger

    break
  else
    echo "$0 : Waiting 5 more seconds for mysql startup" | logger
    sleep 5
    c=$((c + 5))
  fi
done
