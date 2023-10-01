#!/bin/bash

IFS=$'\n'

# Путь к источнику.
IN=/var/www/armad/multi
# Путь к назначению.
OUT=$(mktemp -t -d)

# Перемещение архивов к назначению.
cd ${IN}
for file in $(find . -type f -iname "*.7z" -or -iname "*.rar" -or -iname "*.zip")
do
	dir="${OUT}/$(dirname ${file})"
	mkdir -p ${dir}
	ln -s ${IN}/${file} ${dir}/
done

# Рукурсивная распаковка.
count=1
while [ $count -gt 0 ]
do
	count=0
	cd ${OUT}

	array=( $(find -L . -type f -iname "*.rar") )
	if [ ${#array[@]} -gt 0 ]
	then
		count=$(($count+${#array[@]}))
		for i in "${array[@]}"
		do
			dir="${OUT}/$(dirname ${i})"
			if unrar x -o+ -ad ${i} ${dir}/
			then
				unlink ${i}
			else
				mv ${i} ${i}.skiped
			fi
		done
	fi

	array=( $(find -L . -type f -iname "*.7z") )
	if [ ${#array[@]} -gt 0 ]
	then
		count=$(($count+${#array[@]}))
		for i in "${array[@]}"
		do
			dir="${OUT}/$(dirname ${i})"
			if 7z x -aoa -o${dir}/* -- ${i}
			then
				unlink ${i}
			else
				mv ${i} ${i}.skiped
			fi
		done
	fi

	array=( $(find -L . -type f -iname "*.zip") )
	if [ ${#array[@]} -gt 0 ]
	then
		count=$(($count+${#array[@]}))
		for i in "${array[@]}"
		do
			dir="${i}.x"
			if unzip -o ${i} -d ${dir}/
			then
				unlink ${i}
			else
				mv ${i} ${i}.skiped
			fi
		done
	fi
done
