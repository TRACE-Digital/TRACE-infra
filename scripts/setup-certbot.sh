#!/bin/bash
set -e

TRACE="tracedigital.tk"
CERT_NAME="ec2"
CERTBOT_PORT=8080

# Start the certbot webserver on port 80 and request a cert
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

# Keep this inside the repository
# Helps on a dev machine and especially on Windows since we can also
# make 'certs' a normal folder with self-signed certs if we want
sudo ln -vsf /etc/letsencrypt/live/${CERT_NAME} ./haproxy/certs

# Update certbot's HTTP port since HAProxy should now occupy 80
# and will proxy requests for .well-known/acme-challenge here
sudo sed -ri.bak "s/http01_port.*/http01_port = ${CERTBOT_PORT}/" "/etc/letsencrypt/renewal/${CERT_NAME}.conf"
sed -ri "s/certbot ([^:]*):[0-9]*/certbot \1:${CERTBOT_PORT}/" "./haproxy/haproxy.cfg"

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
