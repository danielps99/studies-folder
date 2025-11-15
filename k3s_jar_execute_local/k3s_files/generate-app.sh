#!/bin/bash
# Generate app-*.yaml from template
# Usage: ./generate-app.sh <PORT> [HOST_IP]
# Example: ./generate-app.sh 22283

PORT=$1
HOST_IP=${2:-"10.1.1.21"}  # Default to 10.1.1.21 if not provided

SERVICE_NAME="my-app-${PORT}-service"
PATH_PREFIX="/app-${PORT}"

# Replace placeholders in template
sed -e "s/PORT/${PORT}/g" \
    -e "s/SERVICE_NAME/${SERVICE_NAME}/g" \
    -e "s|PATH_PREFIX|${PATH_PREFIX}|g" \
    -e "s|HOST_IP|${HOST_IP}|g" \
    app-template.yaml > "app-${PORT}.yaml"

echo "Generated app-${PORT}.yaml"
echo "  Service: ${SERVICE_NAME}"
echo "  Path: ${PATH_PREFIX}"
echo "  Port: ${PORT}"
echo "  Host IP: ${HOST_IP}"

