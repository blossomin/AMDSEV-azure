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
1. sudo ./install.sh
2. sudo reboot
3. extract the guest kernel from deb file
3. download an image file: wget https://saimei.ftp.acc.umu.se/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2
4. use the compiled kernel, ovmf, qemu and the image file to launch a guest: 
    sudo ./launch-qemu.sh -sev-snp -kernel /path/to/guest/kernel  -hda debian-12-nocloud-amd64.qcow2
```