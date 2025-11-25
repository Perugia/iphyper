#!/bin/bash
set -e

echo "Checking /metrics endpoint..."
curl -i "http://localhost:5000/metrics"
