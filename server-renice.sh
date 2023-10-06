#!/bin/bash

IFS=$'\n'


PORTS=$(seq 2302 12 2362)

NICE_NORMAL=0
NICE_LOW=19
IONICE_CLASS_NORMAL=0
IONICE_CLASS_LOW=3
prefix_nft="user_counter"
prefix_difference="prefix_difference"
sleep=20
bytes_idle=$((5 * 1000 * ${sleep}))

fnc_port_getReNice () {
	if [[ $(ssh mikrotik ip/firewall/connection/print | egrep -c "d udp.*:${port}") -gt 0 ]]
	then
		renice=${NICE_NORMAL}
	else
		bytes=$(nft -a list chain inet filter output | grep ${prefix_nft} | grep ${port} | awk '{ print $11 }' | head -n 1)
		if [[ -z ${bytes} ]]
		then
			renice=${NICE_LOW}
			ionice_class=${IONICE_CLASS_LOW}
		else
			str="${prefix_difference}_${port}"
			bytes_old=${!str}
			if [[ -z ${bytes_old} ]]
			then
				bytes_old=${bytes}
			fi

			difference=$((${bytes} - ${bytes_old}))
			eval ${prefix_difference}_${port}=${bytes}

			if [[ ${difference} -gt ${bytes_idle} ]]
			then
				renice=${NICE_NORMAL}
				ionice_class=${NICE_NORMAL}
			else
				renice=${NICE_LOW}
				ionice_class=${IONICE_CLASS_LOW}
			fi
		fi
	fi
}

fnc_renice () {
	if [[ ${renice} -ge 0 ]]
	then
		chrt --pid --idle 0 ${pid}
	else
		chrt --pid --other 0 ${pid}
	fi

	pgid=$(awk '{print $5}' /proc/${pid}/stat)
	renice -n ${renice} --pgrp ${pgid}
	ionice --class ${ionice_class} --pgid ${pgid}

	children=$(cat /proc/${pid}/task/*/children)
	for i in ${children[@]}
	do
		renice -n ${renice} --pid ${i}
		ionice --class ${ionice_class} --pid ${i}
	done
}

while sleep ${sleep}
do
	for port in ${PORTS}
	do
		pids=$(lsof -t -n -i :${port} -a -c ^wineserver)
		if [[ -n ${pids} ]]
		then
			fnc_port_getReNice
			for pid in ${pids[@]}
			do
				fnc_renice
			done
		fi
	done
done