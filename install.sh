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