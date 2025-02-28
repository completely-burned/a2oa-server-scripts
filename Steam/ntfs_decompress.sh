#!/bin/bash

IFS=$'\n'

user_files=$(find /media/ntfs*/SteamLibrary* -type f \( -iname '*.exe' -or -iname '*.dll' \))
user_tmpfile=$(mktemp -t)

for f in ${user_files}
do
	if attr_hex=$(getfattr -e hex -n system.ntfs_attrib_be "${f}" 2>/dev/null | grep system.ntfs_attrib_be)
	then
		attr_hex=$(printf ${attr_hex} | sed '/system\.ntfs_attrib_be=/ { s/^[^0]*0[Xx]/0x/; q }; d')
		attr_hex_compressed=$(($attr_hex | 0x800))

		if [[ $attr_hex -eq $attr_hex_compressed ]]
		then
			attr_hex_decompressed=$(printf '%#010x' $(($attr_hex & ~0x800)))
			rsync --perms "${f}" "${user_tmpfile}"
			truncate -s 0 "${f}"
			setfattr --name=system.ntfs_attrib_be --value="$attr_hex_decompressed" "${f}"
			rsync --perms --remove-source-files "${user_tmpfile}" "${f}"
		fi
	fi
done
