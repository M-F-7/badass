# Mandatory Part

## Questions

Basic functioning of GNS3                                : Simulateur de reseau, pour tester des topologies virtuelles etc...

The global operation and the interest of BGP             : Faire communiquer entre eux deux AS (pas sur de comprendre la question)

The differences between layer 2 and layer 3 in a network : L2 = reseau local, utilise adresses MAC etc | L3 = Reseaux differents, utilise adresses IP

# Part 1

## Definitions

- Packet routing software : Le service demande est FRRouting, il est la pour gerer toute la logique et les protocoles de routage dynamique du systeme

- BGPD 			          : Protocole qui permet aux AS de communiquer entre eux, le protocole "est dans" les routeurs, quand deux routeurs de deux
                            AS differents se rencontrent, ils s'echangent leur carnet d'adresse via une connexion TCP

- OSPFD 		          : Protocole de routage interne qui permet aux routeurs d'un meme reseau de cartographier la topologie du reseau. Les routeurs
                            s'echangent l'etat de leur liaisonse et utilisent un algo pour trouver le chemin le plus rapide vers une adresse IP.

- Routing engine service  : Le service isisd, il sert de moteur pour calculer les routes et gerer le protocole IS-IS .

- IS-IS Protcol           : Protcole de routage interne qui permet aux routeurs de cartographier le reseau (peut fonctionner sans IP).

- Busybox 		          : Logiciel unique qui regroupe des versions light de nombreuses commandes Unix. Utile pour naviguer dans le container

# Part 2

## Definitions 

- VXLAN     : Interface virtuelle qui permet de transporter des trames ethernet (Layer 2) encapsulees dans un paquet UDP (Layer 3/4)
              ce qui permet de faire croire a deux appareils sur des reseaux differents qu'ils sont sur un seul et meme reseau .

- VLAN      : Permet de decouper un reseau physique en plusieurs reseaux logiques (un peu inverse du VXLAN).  

- Switch    : Boitier reseau intelligent qui relie plusieurs appareils au sein du meme reseau, redirige
              les donnes vers le bon destinataire . 

- Bridge    : Switch virtuel qui interconnecte plusieurs interfaces reseau au sein d'une meme machine .

- Broadcast : Mode de transmission qui consiste a envoyer un message a une adresse unique pour qu'il soit duplique
              et recu par toutes les machines presentes sur le reseau local

- Multicast : Mode de transmission qui consiste a envoyer un message a une adresse de groupe specifique afin qu'il
              soit distribue aux machines appartenants a ce groupe

Topologie   : Que les machines du reseau gauche puissent communiquer avec les machines du reseau droit sans avoir a changer d'IP (grace au VXLAN donc)

# Part 3

## Definitions

BGP-EVPN : Comme BGP mais en + on signale quand une machine de notre reseau s'active, et on transmet + d'infos (MAC, VXLAN etc...)
