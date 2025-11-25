#!/bin/bash
set -e

echo "Checking /health endpoint..."
curl -i "http://localhost:5000/health"
