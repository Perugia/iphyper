#!/bin/bash

# Usage:
# ./repeat.sh 50 "curl -i http://localhost:5000/ip/8.8.8.8"

COUNT=$1
CMD=$2

for i in $(seq 1 $COUNT); do
    echo "# $i"
    eval $CMD
    echo ""
done
