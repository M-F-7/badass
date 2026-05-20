FROM alpine:3.19

# busybox: satisfait l'exigence du sujet
# frr: fournit zebra (routing manager) + bgpd + ospfd + isisd
RUN apk add --no-cache busybox busybox-extras frr iproute2

# Verification que zebra est bien present
RUN test -x /usr/lib/frr/zebra

COPY conf/daemons   /etc/frr/daemons
COPY conf/frr.conf  /etc/frr/frr.conf
COPY start.sh       /start.sh

RUN chmod +x /start.sh \
 && chown -R frr:frr /etc/frr

CMD ["/start.sh"]
