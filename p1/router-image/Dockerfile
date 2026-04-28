FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    busybox \
    frr \
    frr-pythontools \
    iproute2 \
    iputils-ping \
    procps \
    tcpdump \
    telnet \
    vim-tiny \
    && rm -rf /var/lib/apt/lists/*

COPY frr/daemons /etc/frr/daemons
COPY frr/frr.conf /etc/frr/frr.conf
COPY start.sh /usr/local/bin/start.sh

RUN chmod 640 /etc/frr/daemons /etc/frr/frr.conf \
    && chown frr:frr /etc/frr/daemons /etc/frr/frr.conf \
    && chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
