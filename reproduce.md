## Reproduce the potential kernel bug on Azure DCas_cc_v5

### 1. build the host kernel and guest, ovmf, qemu
```
git clone -b snp-new https://github.com/blossomin/AMDSEV-azure.git
cd AMDSEV-azure
bash ./build-host.sh
```
### 2. prepare the host VM
what I bought is ubuntu 20.04
```
az vm create -g cvm -n test2 \
  --image /CommunityGalleries/cocopreview-91c44057-c3ab-4652-bf00-9242d5a90170/Images/ubuntu2004-snp-host/Versions/latest \
  --accept-term --size Standard_DC4as_cc_v5 
```

### 3. replace the host kernel
```
0. copy the snp-host-release package to the host VM
1. tar xvf snp-release-2024-03-04.tar.gz && cd snp-release-2024-03-04
2. sudo ./install.sh && sudo reboot
3. extract the guest kernel from deb file: 
    mkdir /path/to/guestdir
    dpkg-deb -R /home/azureuser/snp-release-2024-03-04/linux/guest/linux-image-6.7.0-snp-guest-98543c2aa_6.7.0-g98543c2aa649-2_amd64.deb /path/to/guestdir/
4. download an image file: wget https://saimei.ftp.acc.umu.se/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2
5. use the compiled kernel, ovmf, qemu and the image file to launch a guest: 
    # please use the launch-qemu.sh script in my repo
    sudo ./launch-qemu.sh -sev-snp -kernel /path/to/guest/kernel  -hda debian-12-nocloud-amd64.qcow2
```