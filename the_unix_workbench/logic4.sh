#!/usr/bin/bash

fname=$( echo $url | tr -d '[:punct:]')
if [[ $(date +"%A") = "Friday" ]]
then
	echo "Thank Moses it’s Friday"
fi
