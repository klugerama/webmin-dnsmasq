#!/bin/bash
echo "killing existing process PID is "
cat /var/run/dnsmasq.pid
kill -9 `cat /var/run/dnsmasq.pid`
echo "done. Starting new process..."
/usr/local/sbin/dnsmasq
echo "Done. New PID is "
cat /var/run/dnsmasq.pid

