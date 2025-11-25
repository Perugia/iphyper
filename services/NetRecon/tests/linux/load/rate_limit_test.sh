#!/bin/bash
set -e

echo "Running rate limit test (80 requests)..."

for i in {1..80}; do
  echo "Request $i:"
  curl -i "http://localhost:5000/ip/8.8.8.8"
done
