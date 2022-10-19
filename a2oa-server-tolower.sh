#!/bin/bash
########################################
# Скрипт создает в директории сервера символьные ссылки
# в нижнем регистре на отсутствующие у сервера файлы игры.
#
# Запуск..
# SERVERPATH="путь/к/серверу" ARMA2STEAMPATH="путь/к/a2" ARMA2OASTEAMPATH="путь/к/a2oa" ./a2oa-server-tolower.sh
#
# После обновления игры могут появиться битые ссылки
# на отсутствующие файлы, их нужно удалять.
########################################

IFS=$'\n'



SERVERPATH=${SERVERPATH:-"/opt/steamcmd/a2oa-server/"}

#ARMA2STEAMPATH=${ARMA2STEAMPATH:-"/opt/steamcmd/Steam/steamapps/common/Arma 2"}
#ARMA2OASTEAMPATH=${ARMA2OASTEAMPATH:-"/opt/steamcmd/Steam/steamapps/common/Arma 2 Operation Arrowhead"}
ARMA2STEAMPATH=${ARMA2STEAMPATH:-"/opt/steamcmd/.steam/SteamApps/common/Arma 2"}
ARMA2OASTEAMPATH=${ARMA2OASTEAMPATH:-"/opt/steamcmd/.steam/SteamApps/common/Arma 2 Operation Arrowhead"}
#ARMA2STEAMPATH=/opt/steamcmd/.steam/steamcmd/arma2_files/
#ARMA2OASTEAMPATH=/opt/steamcmd/.steam/steamcmd/arma2oa_files/



########################################
#####          A2
########################################

cd ${ARMA2STEAMPATH}

for DIR in $(find ./ -type d)
do
	if [ ! -d ${SERVERPATH}/ca/${DIR,,} ]
	then
		mkdir -p ${SERVERPATH}/ca/${DIR,,}
	fi
done

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DirectX/*" ! -path "./BEsetup/*")
do

	if [ ! -f ${SERVERPATH}/ca/${FILE,,} ] && [ ! -L ${SERVERPATH}/ca/${FILE,,} ]
	then
		ln -s ${ARMA2STEAMPATH}/${FILE} ${SERVERPATH}/ca/${FILE,,}
	fi
done



########################################
#####          A2OA
########################################

cd ${ARMA2OASTEAMPATH}

for DIR in $(find ./ -type d)
do
	if [ ! -d ${SERVERPATH}/${DIR,,} ]
	then
		mkdir -p ${SERVERPATH}/${DIR,,}
	fi
done

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DirectX/*" ! -path "./BEsetup/*")
do

	if [ ! -f ${SERVERPATH}${FILE,,} ] && [ ! -L ${SERVERPATH}/${FILE,,} ]
	then
		ln -s ${ARMA2OASTEAMPATH}/${FILE} ${SERVERPATH}/${FILE,,}
	fi
done



########################################
#####          ACR
########################################
# Файлы из ACRlite работают, можно играть.

echo "ACR: ACRlite"

ACR_SRC=${SERVERPATH}/dlcsetup/0acrlite
ACR_INTO=${SERVERPATH}/common

echo "ACR: ${ACR_SRC}"

# Временная директория для распаковки.
TMP=$(mktemp -t -d a2oa-server-tolower.XXX)
echo "ACR: Временная директория для распаковки ${TMP}"
for DIR in $(find ${ACR_SRC} -type d)
do
	if [ ! -d ${TMP}/${DIR} ]
	then
		echo "ACR: Create dir ${TMP}/${DIR}"
		mkdir -p ${TMP}/${DIR}
	fi
done

# Распаковка
for FILE in $(find ${ACR_SRC} -type l)
do
	if [ ${FILE##*\.} == "xz" ]
	then
		echo "ACR: Create symlink ${TMP}/${FILE}"
		ln -s ${FILE} ${TMP}/${FILE}
		echo "ACR: Распаковка ${TMP}/${FILE}"
		xz -vdk ${TMP}/${FILE}
		echo "ACR: Удаление ${TMP}/${FILE}"
		rm -v ${TMP}/${FILE}
	fi
done

echo "ACR: Копирование распакованных файлов"
# checksum Чтобы не тревожить напрасно сервер записью.
rsync --recursive --verbose --progress --checksum ${TMP}/ ${ACR_SRC}

echo "ACR: Создаем символьные ссылки ${ACR_SRC} > ${ACR_INTO}"
echo "ACR: Добавляем лишь недостающие файлы, сообщение <<Файл существует>> можно игнорировать."

for FILE in $(find ${ACR_SRC} -name '*.pbo*')
do
	echo "ACR: ${FILE}"
	# dir/
	ln -s ${FILE} ${ACR_INTO}/
done

echo "Удаление ${TMP}"
rm -rfv ${TMP}

exit 0
