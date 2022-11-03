#!/bin/bash
# Этот скрипт не гарантирует 100% работоспособности.

# Заметки.
exit 1

# Путь к источнику.
IN=.
# Путь к назначению. Необходим / в конце.
OUT=~/a2oa-server-private/mpmissions/

# Карты разрешены.
#maps=(utes Chernarus Takistan)

find ${IN} -type f -iname "*.utes.pbo" -print -exec ln -s {} ${OUT} \;
find ${IN} -type f -iname "*.Chernarus.pbo" -print -exec ln -s {} ${OUT} \;

find ${IN} -type f -iname "*.Takistan.pbo" -print -exec ln -s {} ${OUT} \;
find ${IN} -type f -iname "*.Zargabad.pbo" -print -exec ln -s {} ${OUT} \;
find ${IN} -type f -iname "*.Desert_E.pbo" -print -exec ln -s {} ${OUT} \;

find ${IN} -type f -iname "*.ProvingGrounds_PMC.pbo" -print -exec ln -s {} ${OUT} \;

find ${IN} -type f -iname "*.Shapur_BAF.pbo" -print -exec ln -s {} ${OUT} \;

find ${IN} -type f -iname "*.Woodland_ACR.pbo" -print -exec ln -s {} ${OUT} \;
find ${IN} -type f -iname "*.Bootcamp_ACR.pbo" -print -exec ln -s {} ${OUT} \;
find ${IN} -type f -iname "*.Mountains_ACR.pbo" -print -exec ln -s {} ${OUT} \;
