# debian-firewall
A simple and easy way to configure a Debian firewall with iptables.

## About
This project is for users who want to protect themselves from unsolicited network connections.

## Simple Protection
The simple protection feature add the following protections:
 * Block null packets
 * Reject syn-flood attack
 * Reject XMAS packets

## Default Configuration
The default configuration add the following protections:
 * Drop Input Connections
 * Drop Forward Connections
 * Allow Only Established Connections
 * Allow Localhost Connections

## Prerequisite
Iptables should be installed by default on your system. You can verify your installation  with the following command:
```sh
sudo iptables --version
```

If the above command return an error, you can install iptables with the following commmand:
```sh
sudo apt-get install iptables
```


## Firewall Installation & Configuration
This software configure iptables. You can view each command and what they do by looking at the `install.sh` file.

To install and configure the firewall, execute the following command:
```sh
sh install.sh
```
## License
This project is made available under the terms of the MIT License. See the [LICENSE](LICENSE) file for a representation.
