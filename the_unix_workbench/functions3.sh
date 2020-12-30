#!/usr/bin/bash

function howodd {
	local count=0
	for number in $@; do
		if (( $number % 2 == 1 )); then
			let count=$count+1
		fi
	done
	expr "$count / $#" | bc -l
}
