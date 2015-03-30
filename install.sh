#! /bin/bash
#
# debian-firewall
#
# Copyright (c) 2015 Jimmy Beaudoin


# Ask the user for System Updates
echo -n "Do you want to update your system (y/n)[y]? "
read answer
if echo "$answer" | grep -iq "^n" ;then
    echo "# => UPDATE SYSTEM: SKIPPED"
else
    sudo apt-get update
    sudo apt-get -y upgrade
    echo "# => UPDATE SYSTEM: EXECUTED"
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
