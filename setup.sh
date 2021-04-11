#!/bin/bash
set -eo pipefail

PROJECT_DIR="${HOME}/trace-infra"

sudo apt update
sudo apt upgrade -y

sudo snap install core
sudo snap refresh core
sudo snap install certbot docker git

if [ ! -d "${PROJECT_DIR}" ]; then
    git clone https://github.com/TRACE-Digital/TRACE-infra "${PROJECT_DIR}"
fi

cd "${PROJECT_DIR}"

git pull origin

./scripts/setup-certbot.sh
