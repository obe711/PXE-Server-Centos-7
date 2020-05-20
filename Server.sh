#INSTALL PACKAGES
yum -y install vim wget net-tools mc screen openssl rsync git
yum -y install syslinux tftp-server

#DONWLOAD GIT
cd /usr/src/
git clone https://github.com/obe711/PXE-Server-Centos-7.git

#TFTP configure
ln -s '/usr/lib/systemd/system/tftp.socket' '/etc/systemd/system/sockets.target.wants/tftp.socket'
cd /var/lib/tftpboot
yes |cp -fra /usr/src/PXE-Server-Centos-7/isolinux/* /var/lib/tftpboot/
cp /usr/lib/systemd/system/tftp.service /etc/systemd/system
mv /etc/systemd/system/tftp.service /etc/systemd/system/tftp.service.org
yes |cp -fra /usr/src/PXE-Server-Centos-7/conf/tftp.service /etc/systemd/system/tftp.service

systemctl start tftp.socket
systemctl enable tftp.socket
#journalctl -f -n0

# ------------------ REPO LOCAL ------------------
#INSTALL PACKAGES 
yum -y install nginx
yum -y install createrepo epel-release memtest86+

#CREATE MIRROR LOCAL
VERSION="Issabel4-USB-DVD-x86_64-20200102.iso";
URL="http://mirrors.oit.uci.edu/centos/7.6.1810/isos/x86_64";
CHECKOUT_DIR="/usr/src/isobuild";
mkdir -p  ${CHECKOUT_DIR}
mkdir -p /var/www/html/repos/centos/7/{os/x86_64,updates/x86_64}
cd /usr/src && wget ${URL}/${VERSION}
mount -t iso9660 -o loop /usr/src/${VERSION} ${CHECKOUT_DIR}
rsync -a -H  ${CHECKOUT_DIR}/ /var/www/html/repos/centos/7/os/x86_64/
umount ${CHECKOUT_DIR}

#CONFIGURATION NGINX
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.org
yes |cp -fra /usr/src/PXE-Server-Centos-7/nginx/* /etc/nginx/

# TEMPLATE KS
mkdir -p /var/www/html/repos/ks
yes |cp -fra /usr/src/PXE-Server-Centos-7/ks/* /var/www/html/repos/ks/

systemctl start nginx
systemctl enable nginx