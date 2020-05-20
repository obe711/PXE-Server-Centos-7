#!/bin/bash
#
# -------------------------------------------------------------------------------------
# PXE-Server automated installation script for CentOs 7 64bit
# -------------------------------------------------------------------------------------
# This script is only intended as a quickstart to test and get familiar with PXE-Server.
# The HOW-TO should be ALWAYS followed for a fully controlled, manual installation!
# -------------------------------------------------------------------------------------
#
#
# -------------------------------------------------



-------------------- TFTP SERVER ------------------

### TFTP SERVER

ln -s '/usr/lib/systemd/system/tftp.socket' '/etc/systemd/system/sockets.target.wants/tftp.socket'
cd /var/lib/tftpboot
yes |cp -fra /usr/src/PXE-Server/isolinux/* /var/lib/tftpboot/
cp /usr/lib/systemd/system/tftp.service /etc/systemd/system
mv /etc/systemd/system/tftp.service /etc/systemd/system/tftp.service.org
yes |cp -fra /usr/src/PXE-Server/conf/tftp.service /etc/systemd/system/tftp.service


-------------------- OPERATING SYSTEMS ------------------

### CREATE MIRROR LOCAL - CENTOS-7

VERSION="CentOS-7-x86_64-Minimal-1810.iso";
URL="http://mirrors.oit.uci.edu/centos/7.6.1810/isos/x86_64"
CHECKOUT_DIR="/usr/src/isobuild";
mkdir -p  ${CHECKOUT_DIR}
mkdir -p /var/www/html/repos/centos/7/{os/x86_64,updates/x86_64}
cd /usr/src && wget ${URL}/${VERSION}
mount -t iso9660 -o loop /usr/src/${VERSION} ${CHECKOUT_DIR}
rsync -a -H  ${CHECKOUT_DIR}/ /var/www/html/repos/centos/7/os/x86_64/
umount ${CHECKOUT_DIR}



### CREATE MIRROR ISSABEL - CENTOS-7 + ISSABEL/ASTERISK PBX SYSTEM

VERSION="Issabel4-USB-DVD-x86_64-20200102.iso";
URL="http://mirrors.oit.uci.edu/centos/7.6.1810/isos/x86_64";
CHECKOUT_DIR="/usr/src/isobuild";
mkdir -p  ${CHECKOUT_DIR}
mkdir -p /var/www/html/repos/issabel/4/{os/x86_64,updates/x86_64}
cd /usr/src && wget ${URL}/${VERSION}
mount -t iso9660 -o loop /usr/src/${VERSION} ${CHECKOUT_DIR}
rsync -a -H  ${CHECKOUT_DIR}/ /var/www/html/repos/issabel/4/os/x86_64/
umount ${CHECKOUT_DIR}


-------------------- CONFIGURATIONS ------------------

### NGINX

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
yes |cp -fra /usr/src/PXE-Server/nginx/* /etc/nginx/



### KICK START CONFIG

mkdir -p /var/www/html/repos/ks
yes |cp -fra /usr/src/PXE-Server/ks/* /var/www/html/repos/ks/



### PROJECT GIT

#cd /usr/src/
#git clone https://github.com/obe711/PXE-Server.git

