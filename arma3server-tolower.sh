#!/bin/bash
# Скрипт создает в новой директории символьные ссылки в нижнем регистре на файлы.

# Права на запуск...
# chmod +x ~/bin/arma3server-tolower.sh
# Запуск...
# GAME=~/arma3 SERVER=~/arma3lower ~/bin/arma3server-tolower.sh


cd ${GAME}

for DIR in $(find ./ -type d)
do
	if [ ! -d ${SERVER}/${DIR,,} ]
	then
		mkdir -p ${SERVER}/${DIR,,}
	fi
done

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DirectX/*" ! -path "./BEsetup/*")
do
	if [ ! -f ${SERVER}/${FILE,,} ] && [ ! -L ${SERVER}/${FILE,,} ]
	then
		ln -s ${GAME}/${FILE} ${SERVER}/${FILE,,}
	fi
done
