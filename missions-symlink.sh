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
		ln -s "${file}" "${OUT}"/"${v_bn}"
	done

	for dir in $(find ${IN} -type d -iname "*.${map}")
	do
		v_bn=$(basename "${dir}")
		ln -s "${dir}" "${OUT}"/"${v_bn}"
	done
done
