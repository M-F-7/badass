# BADASS Part 2 Runbook

This folder contains a concrete Part 2 setup for the subject topology.

It covers both required modes:

- static VXLAN
- multicast VXLAN

The commands are written for your current naming and images.

## Topology

Place these nodes in GNS3:

- `router_mf7-1`
- `router_mf7-2`
- `host_mf7-1`
- `host_mf7-2`
- one Ethernet switch named `switch_mf7`

Connect them like this:

```text
host_mf7-1 --- router_mf7-1 eth1
                 router_mf7-1 eth0 --- switch_mf7 --- router_mf7-2 eth0
host_mf7-2 --- router_mf7-2 eth1
```

Interface meaning:

- `eth0` on each router = underlay side
- `eth1` on each router = host-facing side
- `eth0` on each host = host NIC

## Addressing Plan

Underlay IP network:

- `router_mf7-1 eth0 = 10.0.0.1/24`
- `router_mf7-2 eth0 = 10.0.0.2/24`

Overlay host network:

- `host_mf7-1 eth0 = 30.1.1.1/24`
- `host_mf7-2 eth0 = 30.1.1.2/24`

The routers do not need an IP on `br0` for this part.

## Files

- `host_mf7-1.sh`: host 1 base config
- `host_mf7-2.sh`: host 2 base config
- `router_mf7-1_static.sh`: router 1 static VXLAN config
- `router_mf7-2_static.sh`: router 2 static VXLAN config
- `router_mf7-1_multicast.sh`: router 1 multicast VXLAN config
- `router_mf7-2_multicast.sh`: router 2 multicast VXLAN config
- `router_reset.sh`: clean router networking state before changing modes

## Order To Apply

### Static mode

1. Start all nodes.
2. Open a console on both hosts and both routers.
3. On both routers, run the reset commands from `router_reset.sh`.
4. Configure the hosts with `host_mf7-1.sh` and `host_mf7-2.sh`.
5. Configure the routers with `router_mf7-1_static.sh` and `router_mf7-2_static.sh`.
6. Test ping between the two routers on the underlay.
7. Test ping between the two hosts on the overlay.
8. Capture traffic on the switch-facing link and inspect the MAC table.

### Multicast mode

1. Keep the same topology.
2. On both routers, run the reset commands from `router_reset.sh`.
3. Reconfigure the hosts if needed with the same host scripts.
4. Configure the routers with `router_mf7-1_multicast.sh` and `router_mf7-2_multicast.sh`.
5. Test host-to-host ping again.
6. Capture traffic and inspect the MAC table again.

## Verification Commands

On each router:

```sh
ip -d link show vxlan10
ip link show br0
bridge fdb show br br0
bridge link show
ping -c 2 10.0.0.2
```

On `router_mf7-2`, replace `10.0.0.2` with `10.0.0.1`.

On each host:

```sh
ip addr show eth0
ping -c 4 30.1.1.2
```

On `host_mf7-2`, replace `30.1.1.2` with `30.1.1.1`.

## What You Should See

Static mode:

- the hosts can ping each other
- `vxlan10` exists with VNI `10`
- `br0` exists and contains `eth1` and `vxlan10`
- the underlay carries UDP port `4789`
- the bridge MAC table learns local and remote MACs

Multicast mode:

- the hosts can still ping each other
- `vxlan10` shows multicast group `239.1.1.1`
- unknown/broadcast traffic uses the multicast group
- the bridge MAC table still learns both local and remote MACs

## Packet Capture

Capture on the underlay side between a router and `switch_mf7`.

During a ping, you should observe:

- ARP from the overlay being carried through VXLAN
- ICMP echo request/reply after ARP resolution
- UDP `4789` traffic on the underlay

## Notes

- These configs do not assign default IP addresses in the base image. They are per-lab runtime configs, which is what the subject expects.
- Reuse the same Part 1 Docker templates.
- Rename `P2` files only if you want a different naming convention, but keep your login in node names inside GNS3.
