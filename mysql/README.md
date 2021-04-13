# TRACE MySQL Instance #

The configuration files in this directory can be used to setup the container
or to initialize a remote database.

## Container ##

General `docker-compose` configuration:

```yml
version: '3.7'

services:
  mysql:
    image: trace/mysql
    build:
      context: mysql
    environment:
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/MYSQL_ROOT_PASSWORD
      - TZ=America/Indiana/Indianapolis
    secrets:
      - MYSQL_ROOT_PASSWORD
    networks:
      - db
    ports:
      - 3306:3306/tcp
    volumes:
      - mysql:/var/lib/mysql

secrets:
  MYSQL_ROOT_PASSWORD:
    file: ./secrets/SOME_FILE_CONTAINING_THE_PASSWORD

networks:
  db:

volumes:
  mysql:
```

## Standalone ##

The `matomo.sh` script can also be used to initialize a standalone MySQL instance.
By providing the correct environment variables, the script is able to do the same
setup routine that it would do within the container.

```sh
apt install default-mysql-client-core

export MYSQL_HOST=<your database host>
export MYSQL_TCP_PORT=3306

source ../secrets/MATOMO_SECRET_ENV
export MYSQL_ROOT_PASSWORD=$(cat ../secrets/MYSQL_ROOT_PASSWORD)
export MATOMO_DATABASE_PASSWORD="${MATOMO_DATABASE_PASSWORD}"

./matomo.sh

unset MYSQL_ROOT_PASSWORD
unset MATOMO_DB_PASSWORD
```
