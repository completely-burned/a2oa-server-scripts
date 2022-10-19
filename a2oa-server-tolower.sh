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

for DIR in $(find ./ -type d); do
	if [ ! -d ${SERVERPATH}/ca/${DIR,,} ]; then
		mkdir -p ${SERVERPATH}/ca/${DIR,,}
	fi
done

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DirectX/*" ! -path "./BEsetup/*")
do

	if [ ! -f ${SERVERPATH}/ca/${FILE,,} ] && [ ! -L ${SERVERPATH}/ca/${FILE,,} ] ; then
		ln -s ${ARMA2STEAMPATH}/${FILE} ${SERVERPATH}/ca/${FILE,,}
	fi
done



########################################
#####          A2OA
########################################

cd ${ARMA2OASTEAMPATH}

for DIR in $(find ./ -type d); do
	if [ ! -d ${SERVERPATH}/${DIR,,} ]; then
		mkdir -p ${SERVERPATH}/${DIR,,}
	fi
done

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DirectX/*" ! -path "./BEsetup/*")
do

	if [ ! -f ${SERVERPATH}${FILE,,} ] && [ ! -L ${SERVERPATH}/${FILE,,} ] ; then
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

# Распаковка
for FILE in $(find ${ACR_SRC} -type l)
do
	if [ ${FILE##*\.} == "xz" ]
	then
		echo "ACR: Распаковка ${FILE}"
		xz -vdfk ${FILE}
	fi
done

echo "ACR: ${ACR_SRC} > ${ACR_INTO}"
echo "ACR: Добавляем лишь недостающие файлы, сообщение <<Файл существует>> можно игнорировать."

for FILE in $(find ${ACR_SRC} -name '*.pbo*')
do
	echo "ACR: ${FILE}"
	# dir/
	ln -s ${FILE} ${ACR_INTO}/
done

exit 0
