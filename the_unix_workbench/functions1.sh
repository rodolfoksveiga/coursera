#!/usr/bin/bash

function plier {
	local multi=1
	for value in $@; do
		let multi=$multi\*$value
	done
	echo $multi	
}
