#!/usr/bin/bash

c1=0
while [[ $c1 -lt $1 ]]; do
	let c1=$c1+1
	for i in {1..2}; do
		echo $i
		for j in this is just a train; do
			echo $j
		done
	done
done
