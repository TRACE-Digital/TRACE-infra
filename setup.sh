#!/bin/bash
set -eo pipefail

PROJECT_DIR="${HOME}/trace-infra"

sudo apt update
sudo apt upgrade -y
sudo apt install -y git certbot docker.io docker-compose

sudo usermod -aG docker "${USER}"

if [ ! -d "${PROJECT_DIR}" ]; then
    git clone https://github.com/TRACE-Digital/TRACE-infra "${PROJECT_DIR}"
fi

cd "${PROJECT_DIR}"

git pull origin

# Need certs to start HAProxy
./scripts/setup-certbot.sh

# Start everyting
docker-compose pull
docker-compose build --pull
docker-compose up -d

# Check that the cerbot proxying works
sudo certbot renew --dry-run
