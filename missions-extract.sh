#!/bin/bash
# Заметки.
exit 1

# Путь к источнику.
#IN=""
# Путь к назначению.
#OUT=$(mktemp -t -d arma-extract.XXX)

cd ${OUT}
# 7z.
find ${IN} -type f -iname "*.7z"  -print -exec 7z -aos x {} *.pbo \;
# RAR.
find ${IN} -type f -iname "*.rar" -print -exec unrar x -o- {} \;
# ZIP.
find ${IN} -type f -iname "*.zip" -print -exec unzip -n {} *.pbo \;
