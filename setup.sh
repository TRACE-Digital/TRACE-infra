#!/bin/bash
set -eo pipefail

PROJECT_DIR="${HOME}/trace-infra"

echo
echo "Installing dependencies..."
echo

sudo apt update
sudo apt upgrade -y
sudo apt install -y git certbot docker.io docker-compose

sudo usermod -aG docker "${USER}"

if [ ! -d "${PROJECT_DIR}" ]; then
    echo
    echo "Cloning repository..."
    echo

    git clone https://github.com/TRACE-Digital/TRACE-infra "${PROJECT_DIR}"
fi

cd "${PROJECT_DIR}"

echo
echo "Updating repository..."
echo
git pull origin

# Need certs to start HAProxy
./scripts/setup-certbot.sh

echo
echo "Starting containers..."
echo

# Start everyting
docker-compose pull
docker-compose build --pull
docker-compose up -d

echo
echo "Testing certificate renewal..."
echo

# Check that the cerbot proxying works
sudo certbot renew --dry-run

echo
echo "Success"
echo
