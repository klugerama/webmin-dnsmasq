#!/bin/bash

if [[ `systemctl is-system-running` =~ running ]]; then 
  echo using systemd
  echo Stopping dnsmasq service...
  systemctl stop dnsmasq.service
  echo "Done. Starting new process..."
  systemctl start dnsmasq.service
  echo "Done."
elif [ -f "/etc/init.d/dnsmasq" ] ; then
  echo using SysV
  echo Stopping dnsmasq service...
  /etc/init.d/dnsmasq stop
  echo "Done. Starting new process..."
  /etc/init.d/dnsmasq start
  echo "Done."
else
  echo "killing existing process PID is "
  cat /var/run/dnsmasq.pid
  kill -9 `cat /var/run/dnsmasq.pid`
  echo "done. Starting new process..."
  eval `which dnsmasq`
  echo "Done. New PID is "
  cat /var/run/dnsmasq.pid
fi

