#!/usr/bin/bash

function nevens {
	local count=0
	for number in $@; do
		if (( $number % 2 == 0 )); then
			let count=$count+1
		fi
	done
	echo $count
}
