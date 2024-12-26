#!/bin/bash
# Из SteamLibraryLinux/ в SteamLibrary/
# создаст копии игровых файлов используя жёсткие ссылки
# чтобы не скачивать каждый раз их заного переключая ОС.
# Обратное направление не работает.
#
# Запуск
# cd SteamLibraryLinux
# ./SteamLibraryLinux.sh

IFS=$'\n'

dir_win="../SteamLibrary"
dir_linux="../SteamLibraryLinux"

dir_steamapps="steamapps"
dir_common="${dir_steamapps}/common"

arr=$(ls ${dir_linux}/${dir_common})

for i in ${arr}
do
	if [[ ! -e "${dir_win}/${dir_common}/${i}" ]]
	then
		cp -rlp "${dir_linux}/${dir_common}/${i}" "${dir_win}/${dir_common}/"
	fi

	for acf in $(grep -ilE "installdir.*${i}" "${dir_steamapps}"/*.acf)
	do
		if [[ ! -z ${acf} ]]
		then
			if [[ ! -f "${dir_win}/${acf}" ]]
			then
				cp -lp "${dir_linux}/${acf}" "${dir_win}/${acf}"
			fi
		fi
	done
done

