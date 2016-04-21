README

These 2 CDs comprise the APC installation kit.

This version of the APC code requires an APC with 2 NICs.  The primary NIC must operate on a static IP 
address, and that IP must be edited in the file /home/digibuddy/conf/apc/digibuddy.ini in place of 
the default IP [192.168.3.99].

The secondary NIC is to be connected directly to the 974 using an ethernet crossover cable.  The APC 
installation script will configure this NIC to operate on the address 192.168.210.99.  The 974's default 
IP address is 192.168.210.1, and should not be changed.

NOTE: future versions of the APC will support 1) DHCP on the APC's primary NIC and 2) a single-NIC system 
allowing one or more 974 to be connected to the same LAN as the APC's primary NIC.  (These 2 scenarios 
are expected to be mutually exclusive since the second requires static IP addresses (as the 974's have no 
DHCP support)).

Disc 1:
debian-31r4-i386
This is the "net installation" disc for Debian 3.1 (Sarge).  It contains a minimal Debian installation and will 
download files as necessary to complete the installation.  This disc is a bootable, menu-driven installation 
disc and is friendly to even novice users.

Disc 2:
APC documentation and installation scripts
