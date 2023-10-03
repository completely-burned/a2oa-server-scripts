#!/bin/bash
#####
# Скрипт находит миссии с поддержкой HeadlessClient
# и создаёт с ними отдельный каталог.
#####

if [[ -z "$(command -v extractpbo)" ]]
then
	exit 1
fi

IFS=$'\n'

MISSIONS=$(pwd)
MISSIONS_HC="${MISSIONS}/mpmissions_hc"

mkdir -p ${MISSIONS_HC}
tmpdir=$(mktemp -t -d split-missions-hc.XXX)
echo "Создан временный каталог ${tmpdir}"

for i in $(ls ${MISSIONS})
do
	dir="${i}"
	if [[ -f "${i}" ]]
	then
		if extractpbo "${i}" ${tmpdir}/
		then
			dir=${tmpdir}
		fi
	fi

	if [[ $(find ${dir} -maxdepth 2 -iname "Mission.sqm" -exec grep -c -i "forceHeadlessClient" {} \;) -gt 0 ]]
	then
		ln -s ${MISSIONS}/"${i}" ${MISSIONS_HC}/
	fi

	rm -r ${tmpdir}/*
done

rmdir -v ${tmpdir}
