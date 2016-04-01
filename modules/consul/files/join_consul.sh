#!/bin/sh

for var in "$@"
do
	echo "$var"
	/opt/consul join $var
done
