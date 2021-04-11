FROM haproxy:lts

RUN apt update && apt install -y \
    netcat-openbsd \
&& rm -rf /var/lib/apt/lists/*

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

EXPOSE 80
EXPOSE 443
