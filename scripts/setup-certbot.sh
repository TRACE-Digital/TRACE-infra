#!/bin/bash
set -eo pipefail

TRACE="tracedigital.tk"
CERT_NAME="ec2"
CERTBOT_PORT=8080

# Start the certbot webserver on port 80 and request a cert
sudo certbot certonly --standalone -n \
    --preferred-challenges http \
    --cert-name "${CERT_NAME}" \
    -d "ec2.${TRACE}" \
    -d "db.${TRACE}" \
    -d "couchdb.${TRACE}" \
    -d "matomo.${TRACE}" \
    -d "analytics.${TRACE}" \
    -d "data.${TRACE}" \
    --dry-run \
    --expand

# Update certbot's HTTP port since HAProxy should now occupy 80
# and will proxy requests for .well-known/acme-challenge here
sed -ri.bak "s/http01_port.*/http01_port = ${CERTBOT_PORT}" "/etc/letsencrypt/renewal/${CERT_NAME}.conf"
sed -ri "s/certbot ([^:]*):[0-9]*/certbot \1:${CERTBOT_PORT}" "./haproxy/haproxy.cfg"

CRON_JOB="30 2 * * * /usr/bin/certbot renew --renew-hook '${PWD}/scripts/certbot-renew-hook.sh' >> /var/log/cert-renewal.log"

# Maintain the existing crontab,
# Filter out our job if already present,
# Add our job
(
    sudo crontab -l 2> /dev/null | grep --invert-match "${CRON_JOB}";
    echo "${CRON_JOB}"
) | sudo crontab -
