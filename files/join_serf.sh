#!/bin/sh

for var in "$@"
do
	echo "$var"
	/opt/serf join $var
done
