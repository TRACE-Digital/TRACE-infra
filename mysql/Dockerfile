FROM mysql:8

# Copy in our initalization scripts
ENV SCRIPT_DIR="/docker-entrypoint-initdb.d/"
COPY *.sql *.sh *.source "${SCRIPT_DIR}"
