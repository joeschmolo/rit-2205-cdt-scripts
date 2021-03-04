#!/bin/sh
#
# Author: Joe Schultz (jxs6799@rit.edu)
#
# Description:  We will build a (fire)wall. It will be a great (fire)wall.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# Flush All Iptables Chains/Firewall rules #
iptables -F

# Delete all Iptables Chains #
iptables -X

# Flush and delete all nat and  mangle #
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow ESTABLISHED and RELATED Connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow Outbound DNS Lookups
iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT -m comment --comment "ALLOW OUTBOUND DNS Connections"

# Allow ICMP
iptables -A INPUT -p icmp -j ACCEPT -m comment --comment "ALLOW INBOUND ICMP Connections"
iptables -A OUTPUT -p icmp -j ACCEPT -m comment --comment "ALLOW OUTBOUND ICMP Connections"

# Allow HTTP
iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT -m comment --comment "ALLOW INBOUND HTTP Connections"
iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT -m comment --comment "ALLOW OUTBOUND HTTP Connections"

# Default Deny
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP
iptables -A OUTPUT -j DROP