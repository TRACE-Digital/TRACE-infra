#!/bin/bash
set -e

TRACE="tracedigital.tk"
CERT_NAME="ec2"
CERTBOT_PORT=8080

# Start the certbot standalone webserver on the normal *port 80* and request a cert
# If this is a fresh install, we have a chicken before/after egg situation:
#   We need a cert to start HAProxy
#   We expect HAProxy to proxy 80 -> CERTBOT_PORT to get certs
sudo certbot certonly --standalone -n \
    --preferred-challenges http \
    --http-01-port 80 \
    --cert-name "${CERT_NAME}" \
    -d "ec2.${TRACE}" \
    -d "db.${TRACE}" \
    -d "couchdb.${TRACE}" \
    -d "matomo.${TRACE}" \
    -d "analytics.${TRACE}" \
    -d "data.${TRACE}" \
    --expand

echo

# Update certbot's HTTP port since HAProxy will occupy 80
# and proxy requests for .well-known/acme-challenge to us
# http01_port won't exist if this is the first run and the default 80 is used above
if ! grep "http01_port" "/etc/letsencrypt/renewal/${CERT_NAME}.conf"; then
    # TODO: Assumes the [renewalparams] section is last
    echo "http01_port = ${CERTBOT_PORT}" | sudo tee -a "/etc/letsencrypt/renewal/${CERT_NAME}.conf"
fi
sudo sed -ri.bak "s/http01_port.*/http01_port = ${CERTBOT_PORT}/" "/etc/letsencrypt/renewal/${CERT_NAME}.conf"

# Symlink the certificates into the secrets directory to keep the
# bind mount for docker within the repository.
# Helps on a dev machine (especially on Windows) since we can create
# 'secrets/certs' as a normal folder and generate self-signed certs
# instead of having to mess with LetsEncrypt
sudo ln -vsf /etc/letsencrypt/live/${CERT_NAME} ./secrets/certs

echo
echo "Adding renewal cron job..."

# Every day at 2:30 AM
CRON_JOB="30 2 * * * /usr/bin/certbot renew --renew-hook '${PWD}/scripts/certbot-renew-hook.sh' >> /var/log/cert-renewal.log"

# Maintain the existing crontab,
# Filter out our job if already present,
# Add our job
( \
    sudo crontab -l 2> /dev/null | grep --invert-match "certbot-renew-hook"; \
    echo "${CRON_JOB}" \
) | sudo crontab -

echo
echo "Renewal cron job added"
sudo crontab -l

# Create the combined PEM file for HAProxy
echo
echo "Running renewal routine..."
sudo bash ./scripts/certbot-renew-hook.sh
