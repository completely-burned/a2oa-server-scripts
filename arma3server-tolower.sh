#!/bin/bash

#####
# Скрипт создает в директории сервера символьные ссылки
# в нижнем регистре на отсутствующие у сервера файлы игры.
#
# Запуск
# GAME="путь/к/a2oa" SERVER="путь/к/серверу" ./arma3server-tolower.sh
#
# После обновления игры могут появиться битые ссылки
# на отсутствующие файлы, их нужно удалять.
#####

IFS=$'\n'

if cd ${GAME}
then
	mkdir -p ${SERVER}

	array=( $(find -L . -not \( -path "./steamapps/common/*" -prune \) \
		-not \( -path "*/shadercache/*" -prune \) \
		-not \( -path "*/steamapps/compatdata/*" -prune \) \
		-not \( -path "*download*" -prune \) \
		-not \( -path "*/temp/*" -prune \) \
		-not \( -path "*/.wine/*" -prune \) \
		-not \( -path "*/.proton/*" -prune \) \
		-type d ) )
	for i in "${array[@]}"
	do
		if [ ! -d ${SERVER}/${i,,} ]
		then
			mkdir ${SERVER}/${i,,}
		fi
	done

	array=( $(find -L . -not \( -path "./steamapps/common/*" -prune \) \
		-not \( -path "*/shadercache/*" -prune \) \
		-not \( -path "*/steamapps/compatdata/*" -prune \) \
		-not \( -path "*download*" -prune \) \
		-not \( -path "*/temp/*" -prune \) \
		-not \( -path "*/.wine/*" -prune \) \
		-not \( -path "*/.proton/*" -prune \) \
		-not \( -iname "appmanifest*.tmp" -prune \) \
		-type f ) )
	for i in "${array[@]}"
	do
		if [ ! -f ${SERVER}/${i,,} ] && [ ! -L ${SERVER}/${i,,} ]
		then
			ln -s ${GAME}/${i} ${SERVER}/${i,,}
		fi
	done
fi
