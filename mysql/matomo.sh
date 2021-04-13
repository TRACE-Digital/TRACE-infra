#!/bin/bash

set -e

# Create a database and a user with permission to that database
# First arg is upercase name, second is the same in lowercase since it's too hard in bash
# Example: create-database test TEST TEST_DATABASE_PASSWORD
create-database() {

    echo ""
    echo "Current user: $(id)"
    echo

    local upper="${1}"
    local lower="${2}"
    local var_name="${3}"

    if [ ! -z "${MYSQL_ROOT_PASSWORD_FILE}" ] && [ -f "${MYSQL_ROOT_PASSWORD_FILE}" ]; then
        local MYSQL_ROOT_PASSWORD=$(cat "${MYSQL_ROOT_PASSWORD_FILE}")
    fi

    if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
        echo
        echo "Missing MySQL root password. Set MYSQL_ROOT_PASSWORD or MYSQL_ROOT_PASSWORD_FILE."
        echo
        exit 1
    fi

    # Source a file containing variables
    # This can be the same as the env_file from docker-compose.yml
    local SECRET_ENV_FILE="/run/secrets/${upper}_SECRET_ENV"
    if [ -f "${SECRET_ENV_FILE}" ]; then
        source "${SECRET_ENV_FILE}"
    fi

    local DB_PASSWORD="${!var_name}"

    if [ -z "${DB_PASSWORD}" ]; then
        echo
        echo "Failed to determine database password for ${upper}"
        echo
        echo "Set ${var_name} or provide it in ${SECRET_ENV_FILE}"
        echo
        exit 1
    fi

    user="${MYSQL_USER:-root}"
    host="${MYSQL_HOST:-127.0.0.1}"
    port="${MYSQL_TCP_PORT:-3306}"

    echo "Connecting to MySQL ${user}@${host}:${port}..."
    echo

    # TODO: Restrict privledges
    # TODO: Allow restricting allowed hosts
    mysql --host "${host}" --port "${port}" --user="${user}" --password="${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE ${lower};
        CREATE USER '${lower}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${lower}.* TO '${lower}'@'%';
EOSQL

    echo
    echo "done"
}

create-database MATOMO matomo MATOMO_DATABASE_PASSWORD
