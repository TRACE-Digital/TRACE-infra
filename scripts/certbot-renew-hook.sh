#!/bin/bash
set -eo pipefail

CERT_NAME="ec2"

if [ "${EUID}" != "0" ]; then
    echo "Should be run as root since it runs from the cron job!"
    echo
    exit 1
fi

echo "Creating combined cert..."
echo

cd "/etc/letsencrypt/live/${CERT_NAME}"

# Create a combined PEM file for HAProxy
cat "fullchain.pem" "privkey.pem" > "combined.pem"
chmod 600 "combined.pem"

echo "Updating certs in HAProxy..."

if docker ps | grep "proxy" > /dev/null; then
    # https://www.haproxy.com/documentation/hapee/2-3r1/management/starting-stopping/#reload-the-configuration
    docker exec proxy bash -c 'kill -SIGUSR2 $(cat /run/haproxy.pid)' || echo "Could not update live certs"

    # Can also use the runtime API to update the cert but it's a bit more complicated/fragile for our setup
    # Have to add:
    #
    # global
    #  # Enable the runtime API so we can reload SSL certs
    #  stats socket /run/haproxy-api.sock mode 600 level admin
    #
    # to haproxy.cfg
    # https://www.haproxy.com/blog/dynamic-ssl-certificate-storage-in-haproxy/
    #
    # API="nc -U /run/haproxy-api.sock"
    # CERT_CONTENTS=$(cat combined.pem)
    # # docker exec proxy bash -c "echo 'show ssl cert' | ${API}"
    # # docker exec proxy bash -c "echo 'show ssl cert /certs/combined.pem' | ${API}"
    # docker exec proxy bash -c "echo -e 'set ssl cert /certs/combined.pem <<\n${CERT_CONTENTS}\n' | ${API}"
    # # docker exec proxy bash -c "echo 'show ssl cert' | ${API}"
    # # docker exec proxy bash -c "echo 'show ssl cert */etc/haproxy/certs/site.pem' | ${API}"
    # docker exec proxy bash -c "echo 'commit ssl cert /etc/haproxy/certs/site.pem' | ${API}"
else
    echo "Proxy container was not active."
fi

cd -
