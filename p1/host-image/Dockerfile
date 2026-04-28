FROM alpine:3.20

RUN apk add --no-cache \
    busybox-extras \
    iproute2 \
    iputils \
    tcpdump

COPY start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
