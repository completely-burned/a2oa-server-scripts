#!/bin/bash

service="a2oa-server-wine.service"
exe="Z:\opt\steamcmd\a2oa-server\arma2oaserver.exe"
# Необходим / в конце.
WINEPREFIX=/opt/steamcmd/a2oa-server/.wine/
sleep=10

while :
do
	# Return.
	if [[ -n $(find ${WINEPREFIX} -iname '*.mdmp' -print -delete) ]]
	then
		echo "kill ${exe}"
		systemctl is-active --quiet ${service} \
		&& kill $(pidof ${exe})
	fi

	sleep ${sleep};
done
