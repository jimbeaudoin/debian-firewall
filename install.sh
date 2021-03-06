#! /bin/bash
#
# debian-firewall
#
# Copyright (c) 2015 Jimmy Beaudoin


# Ask the user for System Updates
echo -n "Do you want to update your system (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => SYSTEM UPDATE: SKIPPED"
else
    sudo apt-get update
    sudo apt-get -y upgrade
    echo "# => SYSTEM UPDATE: EXECUTED"
fi

# Ask the user for Firewall Rules Cleanup
echo -n "Do you want to cleanup the current firewall rules (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => CLEANUP FIREWALL RULES: SKIPPED"
else
    sudo iptables -F
    echo "# => CLEANUP FIREWALL RULES: EXECUTED"
fi

# Ask the user for Simple Protection
echo -n "Do you want to add a simple protection (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => SIMPLE PROTECTION: SKIPPED"
else
    # Block null packets
    sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
    # Reject syn-flood attack
    sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
    # Reject XMAS packets
    sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
    echo "# => SIMPLE PROTECTION: EXECUTED"
fi

# Ask the user for HTTP (80) connections
echo -n "Do you want to allow HTTP (port 80) connections (y/n)[n]? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
    echo "# => ALLOW HTTP CONNECTIONS: EXECUTED"
else
    echo "# => ALLOW HTTP CONNECTIONS: SKIPPED"
fi

# Ask the user for HTTPS (443) connections
echo -n "Do you want to allow HTTPS (port 443) connections (y/n)[n]? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    sudo iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
    echo "# => ALLOW HTTPS CONNECTIONS: EXECUTED"
else
    echo "# => ALLOW HTTPS CONNECTIONS: SKIPPED"
fi

# Ask the user to secure IPv6 connections
echo -n "Do you want to secure IPv6 connections (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => CLOSE IPv6 CONNECTIONS: SKIPPED"
else
    # DROP IPv6 Connections
    sudo ip6tables -P INPUT DROP
    sudo ip6tables -P OUTPUT ACCEPT
    sudo ip6tables -P FORWARD DROP
    # Accept localhost (internal) connection
    sudo ip6tables -A INPUT -i lo -j ACCEPT
    echo "# => CLOSE IPv6 CONNECTIONS: EXECUTED"
fi

# Execute Default Configuration
# Allow localhost connection & established connections
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# DROP ALL others INPUT/FORWARD connections
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP

# WARNING: OUTPUT connections should be closed and configured carefully
# on highly secured system.
# Accept all OUTPUT connections
sudo iptables -P OUTPUT ACCEPT
echo "# => DEFAULT CONFIGURATION: EXECUTED"

# Ask the user to save the rules permanently
echo -n "Do you want to save the new firewall rules permanently (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => SAVE RULES PERMANENTLY: SKIPPED"
else
    sudo apt-get install iptables-persistent
    sudo service iptables-persistent start
    echo "# => SAVE RULES PERMANENTLY: EXECUTED"
fi

echo "# => FIREWALL CONFIGURATION: EXECUTED"
echo "# => END"
