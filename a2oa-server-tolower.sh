#!/bin/bash

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

for FILE in $(find ./ -type f ! -path "./ACR/*" ! -path "./PMC/*" ! -path "./BAF/*" ! -path "./DLCsetup/*" ! -path "./DirectX/*" ! -path "./BEsetup/*"); do

	if [ ! -f ${SERVERPATH}/ca/${FILE,,} ] && [ ! -L ${SERVERPATH}/ca/${FILE,,} ] ; then
		ln -snf ${ARMA2STEAMPATH}/${FILE} ${SERVERPATH}/ca/${FILE,,}
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

for FILE in $(find ./ -type f ! -path "./_ACR/*" ! -path "./_PMC/*" ! -path "./_BAF/*" ! -path "./DLCsetup/*" ! -path "./DirectX/*" ! -path "./BEsetup/*"); do

	if [ ! -f ${SERVERPATH}${FILE,,} ] && [ ! -L ${SERVERPATH}/${FILE,,} ] ; then
		ln -snf ${ARMA2OASTEAMPATH}/${FILE} ${SERVERPATH}/${FILE,,}
	fi
done



########################################
#####          ACR
########################################

ACR_SRC=${ARMA2OASTEAMPATH}/DLCsetup/0ACRlite
ACR_INTO=${SERVERPATH}/acr/addons

cd ${ACR_SRC}

for DIR in $(find ./ -type d); do
	if [ ! -d ${ACR_INTO}/${DIR,,} ]; then
		mkdir -p ${ACR_INTO}/${DIR,,}
	fi
done

for FILE in $(find ./ -type f); do

	if [ ! -f ${ACR_INTO}/${FILE,,} ] && [ ! -L ${ACR_INTO}/${FILE,,} ] ; then
		ln -snf ${ACR_SRC}/${FILE} ${ACR_INTO}/${FILE,,}
	fi
done

cd ${ACR_INTO}
for FILE in $(find ./ -type l); do

	if [ ${FILE##*\.} == "xz" ] ; then
		xz -dfk ${FILE}
	fi
done

cd "${SERVERPATH}"

exit 0
