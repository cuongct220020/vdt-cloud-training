# VPN Server Setup

> Set up a WireGuard or OpenVPN server to secure remote access.

The goal of this project is to set up your own VPN server to secure your internet traffic when on untrusted networks (like public WiFi) and to access your private network remotely. You will configure a VPN server using either WireGuard (modern and simple) or OpenVPN (widely compatible), and connect to it from your devices.

## Prerequisites

Before starting this project, you should have:

* A Linux server with a public IP address (VPS from any cloud provider)
* Basic Linux command-line skills
* Firewall configured (UFW or iptables)
* Understanding of basic networking concepts (IP addresses, ports, routing)

## Requirements

Choose one of the following VPN solutions and complete the setup:

### Option 1: WireGuard (Recommended)

WireGuard is a modern, fast, and simple VPN protocol built into the Linux kernel.

* Install WireGuard on your server
* Generate server and client key pairs (public and private keys)
* Configure the WireGuard interface (`wg0.conf`) with appropriate IP ranges
* Enable IP forwarding and configure NAT rules for traffic routing
* Open the WireGuard port (default: 51820/UDP) in your firewall
* Start and enable the WireGuard service
* Create client configuration files for your devices

### Option 2: OpenVPN

OpenVPN is a mature, widely-supported VPN solution with broad client compatibility.

* Install OpenVPN and Easy-RSA on your server
* Set up a Certificate Authority (CA) and generate server certificates
* Configure the OpenVPN server (`server.conf`)
* Enable IP forwarding and configure NAT rules
* Open the OpenVPN port (default: 1194/UDP) in your firewall
* Generate client certificates and create `.ovpn` configuration files

### After Server Setup (Both Options)

* Install the VPN client on your phone, laptop, or other devices
* Import the client configuration and connect to your VPN server
* Verify your traffic is routed through the VPN (check your public IP)
* Test DNS resolution to ensure there are no DNS leaks
* Add multiple client configurations (e.g., phone, laptop, tablet)

## Stretch Goals

* Configure split tunneling to only route specific traffic through the VPN
* Set up a Pi-hole or AdGuard alongside your VPN for ad-blocking
* Configure automatic connection on untrusted networks
* Set up monitoring to track connected clients and bandwidth usage

## Learning Outcomes

After completing this project, you will understand how VPNs work at a technical level, including tunneling, encryption, and traffic routing. You will be able to secure your internet traffic on untrusted networks and access your private resources remotely. These skills are valuable for personal security, remote work scenarios, and managing secure connections to cloud infrastructure.