Host image : 
https://github.com/Joshua-Riek/ubuntu-rockchip#installation
https://joshua-riek.github.io/ubuntu-rockchip-download/boards/orangepi-5.html

Ubuntu cloud VM :
https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img


# First install on 24.04 : 

# flash the board to boot on ssd !!

# image . ok with "raspberrypi imager"

## OP5: 
https://joshua-riek.github.io/ubuntu-rockchip-download/boards/orangepi-5.html

https://github.com/Joshua-Riek/ubuntu-rockchip/releases/download/v2.4.0/ubuntu-24.04-preinstalled-server-arm64-orangepi-5.img.xz

## OP5+ --> virt-install is not working properly with 24.04  
https://joshua-riek.github.io/ubuntu-rockchip-download/boards/orangepi-5-plus.html

https://github.com/Joshua-Riek/ubuntu-rockchip/releases/download/v2.4.0/ubuntu-24.10-preinstalled-server-arm64-orangepi-5-plus.img.xz

credentials : ubuntu/ubuntu

# setup host image :

1. (mac) hosts
2. (server) /etc/hostname
3. users:
    ```$ sudo useradd -m rom```
    ```$ sudo chsh -s /bin/bash rom -> set bash instead of sh as default shell```
    ```$ sudo passwd rom -> see "pass" file ```
    ```$ sudo vim /etc/default/keyboard -> keyboard layout to "fr"```
4.  ```$ sudo apt-get update & sudo apt-get upgrade```
5. ```$ sudo usermod -aG sudo rom```
6. use sudo with no password IF NEEDED :
   ```$ sudo echo 'rom ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/rom```
   ```$ sudo chmod 440 /etc/sudoers.d/rom```

5. delete ubuntu user
```$ sudo deluser --remove-home ubuntu```

7. SSH : 
    1. create ssh on client :
    ```ssh-keygen -t rsa -b 4096 -C "rom@op5p1" -f ~/.ssh/rom_op5p1```
    2. copy public key to the server : 
    ```ssh-copy-id -i rom_op5p1.pub rom@op5p1```
    3. add lines to ~/.ssh/config :
    ```
    Host op5p1
        HostName op5p1
        User rom
        IdentityFile ~/.ssh/rom_op5p1
        IdentitiesOnly yes
    ```
8. setup ufw :


9. setup fail2ban:
    ```apt-get install fail2ban```
10. setup logging report system (logwatch ??)

# create bridge from host + prevent the mac address from changing at each boot : 
sudo vim /etc/netplan/10-dhcp-all-interfaces.yaml
## replace MAC + interface name
```
network:
  version: 2
  ethernets:
    enP3p49s0:
      dhcp4: no
  bridges:
    br0:
      dhcp4: yes
      macaddress: C0:74:2B:FF:6E:DB
      interfaces:
        - enP3p49s0
```

```$ sudo systemctl restart systemd-networkd.service```



# install kvm/libvirt + bridge utils :
```
$ sudo apt install --no-install-recommends libvirt-daemon \
  libvirt-daemon-system libvirt-clients qemu-kvm qemu-system-arm \
  qemu-utils qemu-efi-aarch64 qemu-efi-arm arm-trusted-firmware \
  seabios bridge-utils virtinst dnsmasq-base ipxe-qemu libguestfs-tools \
  libosinfo-bin cloud-image-utils
```
# + apt install virt-manager ???

# create group IF NECESSARY : 
  $ sudo groupadd libvirt

  $ sudo adduser $USER libvirt
  ($ sudo usermod -aG libvirt $USER)

  $ sudo adduser $USER kvm
  $ newgrp libvirt

### uncomment qemu:///system in
  $ cp /etc/libvirt/libvirt.conf ~/.config/libvirt/
### OR
  $ export LIBVIRT_DEFAULT_URI=qemu:///system

sudo systemctl status libvirtd




# plug the bridge with virsh : 
## create the file kvm-hostbridge.xml : 
```vim kvm-hostbridge.xml```
<network>
        <name>hostbridge</name>
        <forward mode="bridge"/>
        <bridge name="br0"/>
</network>

## plug it : 
```
virsh net-define kvm-hostbridge.xml
virsh net-start hostbridge
virsh net-autostart hostbridge
virsh net-list
```

# Create cloud init image : 

## ssh
```
ssh-keygen -t ed25519 -f ~/.ssh/rom_<node> -C "rom@<node>"
```

# go to /var/lib/libvirt/images
## copy user-data and ```user-data``` and ```meta-data``` in /var/lib/libvirt/images
  -> get related files in the same folder

## run from /var/lib/libvirt/images : 
```$ sudo wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-arm64.img   -P /var/lib/libvirt/images```

```$ sudo qemu-img create -b /var/lib/libvirt/images/jammy-server-cloudimg-arm64.img   -F qcow2 -f qcow2 /var/lib/libvirt/images/ubuntu.qcow2```

```$ sudo cloud-localds seed.iso user-data meta-data```

```
$ virt-install --name ubuntu \
    --memory 8000 \
    --arch aarch64 \
    --vcpus 4 \
    --disk /var/lib/libvirt/images/ubuntu.qcow2,device=disk,bus=virtio \
    --disk seed.iso,device=cdrom \
    --os-variant=ubuntu22.04 \
    --graphic none \
    --network network=hostbridge \
    --boot loader=/usr/share/AAVMF/AAVMF_CODE.fd,loader.readonly=yes,loader.type=pflash \
    --import
```

OR : network=hostbridge

------------------------

Commands : virsh list --all

$ virsh shutdown ubuntu
$ virsh destroy ubuntu
$ virsh undefine ubuntu --nvram
$ sudo rm /var/lib/libvirt/images/ubuntu.qcow2



============GARBAGE================

