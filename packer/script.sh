#!/bin/bash

set -xe
export DEBIAN_FRONTEND=noninteractive

pushd /tmp/
wget -nv https://github.com/jepio/AMDSEV/releases/download/v2024.02.07/linux-image-6.7.0-rc6-next-20231222-snp-host-0fcebf5ce3fe_6.7.0-rc6-10385-g0fcebf5ce3fe-2_amd64.deb
wget -nv https://github.com/jepio/AMDSEV/releases/download/v2024.02.07/snp-qemu_2024.02.07-0_amd64.deb
apt-get update
apt-get install -y -f ./*.deb

rm *.deb
popd

mkdir -p /usr/local/sbin
wget -nv -O /usr/local/sbin/snphost https://github.com/jepio/AMDSEV/releases/download/v2023.05.25/snphost
chmod +x /usr/local/sbin/snphost

modprobe nbd
qemu-nbd -c /dev/nbd0 /usr/local/share/snp-qemu/*.qcow2
mount /dev/nbd0p1 /media/
pushd /media
mkdir -p usr/local/sbin
wget -nv -O usr/local/sbin/snpguest https://github.com/jepio/AMDSEV/releases/download/v2023.05.25/snpguest
chmod +x usr/local/sbin/snpguest
popd
umount /media
qemu-nbd -d /dev/nbd0

/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync

fstrim -va
