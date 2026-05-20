FROM alpine:3.19

# busybox: outils de base
# frr: zebra + bgpd + ospfd (necessaires pour OSPF + BGP EVPN)
# iproute2: ip, bridge (gestion interfaces, bridge, VXLAN)
RUN apk add --no-cache busybox busybox-extras frr iproute2

RUN test -x /usr/lib/frr/zebra

COPY conf/daemons   /etc/frr/daemons
COPY conf/frr.conf  /etc/frr/frr.conf
COPY start.sh       /start.sh

RUN chmod +x /start.sh \
 && chown -R frr:frr /etc/frr

CMD ["/start.sh"]
