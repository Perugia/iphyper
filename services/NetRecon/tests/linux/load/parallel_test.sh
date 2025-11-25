#!/bin/bash
set -e

echo "Making 20 parallel requests..."

for i in {1..20}; do
  curl -s "http://localhost:5000/ip/1.1.1.1" &
done

wait
echo "Done!"
