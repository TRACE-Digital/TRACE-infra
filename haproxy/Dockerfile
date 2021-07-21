FROM haproxy:lts

USER root

RUN apt update && apt install -y \
    netcat-openbsd \
&& rm -rf /var/lib/apt/lists/*

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

# Can drop this eventually. Need to read the certs for now
# USER haproxy

EXPOSE 80
EXPOSE 443
