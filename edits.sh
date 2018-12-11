#!/bin/bash

# usage ./refactor basename #97 90  79 49 33  29 09 02

if [ "$#" -lt 2 ]
then
	echo "usage ./refactor basename 1 2 3 ..."
	exit 1
fi

base="$1"
shift 1
for fn in  "$@" 
do
	vi "$base"_"$fn".json
done
