# GNS3 Template Settings for Part 1

This file documents the minimal GNS3 settings to use the two Docker images created for `BADASS` Part 1.

## Image Names

After building the images, the local Docker image names are:

- `badass-host:latest`
- `badass-router:latest`

Build command:

```sh
./build-images.sh
```

## Host Template

Suggested values:

- Template type: Docker container
- Image: `badass-host:latest`
- Adapters: `1` for Part 1
- Console type: default Docker console
- Start command: leave default entrypoint
- Network mode: prefer `none` if the GNS3 template exposes this option
- Extra hosts: none
- Environment: none required

Purpose:

- simple endpoint node
- shell access through GNS3 console
- later traffic generation with `ping` and basic tools

## Router Template

Suggested values:

- Template type: Docker container
- Image: `badass-router:latest`
- Adapters: `4`
- Console type: default Docker console
- Start command: leave default entrypoint
- Network mode: prefer `none` if the GNS3 template exposes this option
- Extra hosts: none
- Environment: none required

Recommended runtime privilege for the router node:

- enable `--privileged` in the GNS3 Docker template options if available

Why:

- the router will need kernel networking features
- later parts will create VXLAN interfaces and bridges
- FRR must be able to interact cleanly with the Linux networking stack

## Part 1 Topology

Minimal topology expected by the subject:

```text
host_<login>-1 ---- router_<login>-1
```

Examples with your login:

```text
host_mf7-1 ---- router_mf7-1
```

## What to Check After Boot

For the host node:

- console opens
- `ip link` shows the interface
- no IP is configured by default

For the router node:

- console opens
- `ip link` shows all interfaces
- `ps aux | grep frr` shows FRR processes
- `vtysh -c 'show daemons'` works
- no interface has a default IP address

## Notes About the Base Router Config

The provided router image enables these FRR daemons:

- `zebra`
- `bgpd`
- `ospfd`
- `isisd`
- `staticd`

The included `frr.conf` is intentionally generic:

- it enables the routing stack
- it does not assign interface IP addresses
- it is only a base image config for reuse in Parts 2 and 3

Important note:

- plain `docker run` usually gives the container a default Docker bridge IP such as `172.17.x.x`
- that address is injected by Docker networking, not by the image configuration itself
- for GNS3, prefer a mode where only GNS3-managed interfaces exist if that option is available

## Final Submission Reminder

The subject expects the part folder to be named `P1` at the repository root.

The repository currently uses `p1/`, so rename it before final submission if you want exact subject compliance.
