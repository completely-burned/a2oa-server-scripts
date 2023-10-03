#!/bin/sh

# cd ~/arma3

# CBA вожможно не приводит к ошибкам.
# terrains, maps вожможно не приводят к ошибкам.
find -L . \
	\( \
		-not \( -path "*cache*" -prune \) \
		-not \( -path "*compatdata*" -prune \) \
		-not \( -path "*download*" -prune \) \
		-not \( -path "*temp*" -prune \) \
		-not \( -path "*wine*" -prune \) \
		-not \( -path "*proton*" -prune \) \
	\) \
	-path '*workshop*' \
	-path '*addon*' \
	-path '*mod*' \
	-path "*/steamapps/common/*" \
	\( \
		-iname '*map*.bikey' -or \
		-iname '*terrain*.bikey' -or \
		-iname 'ibr_panthera*.bikey' -or \
		-iname '*cba*.bikey' \
	\) \
	-print \
	-exec ln -s {} ./keys/ \;
