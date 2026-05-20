# Commandes p2 — VXLAN

Reference rapide : chaque commande utilisée dans la mise en place de la topo, avec ce qu'elle fait.

---

## Interfaces

```sh
ip link
```
Liste les interfaces réseau (eth0, lo, bridges, etc.) et leur état (UP/DOWN).

```sh
ip link set eth0 up
```
Active l'interface `eth0`. Tant qu'elle est DOWN, elle ne transmet rien.

```sh
ip link set eth0 down
```
Désactive l'interface.

```sh
ip link del vxlan10
```
Supprime une interface virtuelle (utile pour repartir propre).

---

## Adresses IP

```sh
ip addr add 10.1.0.2/24 dev eth0
```
Attribue l'IP `10.1.0.2` à `eth0`, avec un masque `/24` (= subnet `10.1.0.0/24`). Le masque dit au kernel quelles IPs sont "voisines directes" (joignables sans routeur).

```sh
ip addr del 10.1.0.2/24 dev eth0
```
Retire l'IP.

```sh
ip addr
```
Affiche toutes les interfaces avec leurs IPs.

---

## Routage

```sh
ip route
```
Affiche la table de routage : quelles destinations passent par quelle passerelle / interface.

```sh
ip route add default via 10.1.0.1
```
Définit la **passerelle par défaut**. Tout paquet vers une destination non connue part vers `10.1.0.1`. Indispensable sur les hosts.

```sh
ip route add 10.2.0.0/24 via 10.0.0.2
```
Ajoute une route statique : "pour atteindre le réseau `10.2.0.0/24`, envoie via `10.0.0.2`". Sur les routeurs, ça leur dit comment atteindre les subnets distants.

```sh
echo 1 > /proc/sys/net/ipv4/ip_forward
```
Active le **forwarding IP** sur le kernel. Sans ça, un Linux qui reçoit un paquet pas pour lui le jette. C'est ce qui transforme une machine en routeur.

---

## Bridge

Un bridge est un **switch logiciel** : il met plusieurs interfaces dans le même domaine L2.

```sh
ip link add br0 type bridge
```
Crée un bridge nommé `br0`.

```sh
ip link set br0 up
```
Active le bridge.

```sh
ip link set vxlan10 master br0
```
Attache `vxlan10` au bridge `br0` — `vxlan10` devient un "port" du switch logiciel.

```sh
ip addr add 30.1.1.1/24 dev br0
```
Donne une IP au bridge lui-même. C'est cette IP qui sera utilisée pour parler à travers le VXLAN.

```sh
bridge link
bridge fdb show
```
Inspecte le bridge : interfaces attachées et table des MACs apprises.

---

## VXLAN

VXLAN = tunnel qui encapsule des trames Ethernet dans de l'UDP, pour étendre un LAN par-dessus du routage IP.

```sh
ip link add vxlan10 type vxlan id 10 remote 10.2.0.2 dstport 4789 dev eth0
```
Crée une interface VXLAN, **mode statique** :
- `id 10` : VNI (identifiant du segment VXLAN).
- `remote 10.2.0.2` : IP du VTEP d'en face (unicast).
- `dstport 4789` : port UDP standard RFC 7348.
- `dev eth0` : interface physique qui porte le tunnel.

```sh
ip link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 4789 dev eth0
```
Variante **mode multicast** : au lieu de pointer un voisin précis, on rejoint le groupe multicast `239.1.1.1`. Tous les VTEPs du groupe se découvrent dynamiquement.

```sh
ip -d link show vxlan10
```
Détails du VXLAN (vni, remote/group, port).

---

## Vérifications

```sh
ping -c 3 30.1.1.2
```
Test de connectivité (3 paquets puis stop).

```sh
tcpdump -i eth0 udp port 4789 -nn
```
Capture le trafic VXLAN encapsulé sur `eth0`. Tu vois les paquets UDP/4789.

```sh
tcpdump -i vxlan10 -nn
```
Capture à l'intérieur du tunnel — le trafic en clair (ARP, ICMP, etc.) tel que les hosts le voient.
