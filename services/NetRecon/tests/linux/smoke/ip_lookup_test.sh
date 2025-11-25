#!/bin/bash
set -e

echo "Running IP lookup test..."
curl -i "http://localhost:5000/ip/8.8.8.8"
