#!/usr/bin/bash

function fib {
	local array=($(seq 1 $1))
	for i in {1..10}; do
		if [[ $i -le 2 ]]; then
			array[$i]=$(($array[$i]-1))
		else
			array[$i]=$array[$(($i-1))]
		fi
	done
	echo $array
}
