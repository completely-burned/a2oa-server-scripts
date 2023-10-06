#!/bin/bash
# Этот скрипт не гарантирует 100% работоспособности.

IFS=$'\n'

# Путь к источнику.
IN=/var/www/armad/multi
# Путь к назначению.
OUT=~/a2oa-server/mpmissions/

# Карты разрешены.
MAPS="utes
Chernarus
Takistan
Zargabad
Desert_E
ProvingGrounds_PMC
Shapur_BAF
Woodland_ACR
Bootcamp_ACR
Mountains_ACR
FDF_Isle1_a"

# TODO: Чёрный список миссий.
BLACKLIST="*invasion*
*i44*
*1944*
"

for map in ${MAPS}
do
	for file in $(find ${IN} -type f -iname "*.${map}.pbo")
	do
		v_bn=$(basename "${file}")
		# ln: не удалось создать символьную ссылку '': Файл существует
		if [[ ! -f "${OUT}"/"${v_bn}" ]]
		then
			ln -sv "${file}" "${OUT}"/"${v_bn}"
		fi
	done

	for dir in $(find ${IN} -type d -iname "*.${map}")
	do
		v_bn=$(basename "${dir}")
		# find: File system loop detected; '' is part of the same file system loop as ''
		if [[ ! -d "${OUT}"/"${v_bn}" ]]
		then
			if [[ -n $(find ${dir} -maxdepth 1 -iname "Mission.sqm") ]]
			then
				ln -sv "${dir}" "${OUT}"/"${v_bn}"
			fi
		fi
	done
done
