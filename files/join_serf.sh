#!/bin/sh
#
# File: (>>FILE<<)
#
# Created: (>>DATE<<) by Carlos Amedee
#
for var in "$@"
do
	echo "$var"
	/opt/serf join $var
done
