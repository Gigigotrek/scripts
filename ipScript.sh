#!/bin/sh
### Check connectivity every 60 sec
while sleep 60
do
  for ip in 192.168.1.100 192.168.1.102 192.168.0.7
  do
    if ping -c 1 -t 2 $ip >/dev/null then
      echo “$ip da OK”
    else
      echo “$ip perdió un paquete”
      ## Wait 10 sec and try again
      sleep 10
      if ! ping -c 1 -t 2 $ip >/dev/null then
        echo “$ip perdió dos paquetes, reiniciando…”
        reboot
      fi
    fi
  done
done 2>&1
