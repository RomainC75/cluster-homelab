# First install.
## Not needed if the sbc has been flashed !!!

# set dhcp and /etc/hosts

# 1st connection
user : orangepi
pass : orangepi
Are you sure you want to continue connecting (yes/no/[fingerprint])?

# 1rt upgrade 
```
sudo apt update
sudo apt upgrade -y
sudo apt install gdisk
```

# orangepi-config
configure : 
- system/zsh
- personal/timezone
- personal/keyboard
- personal/hostname <- node name ? 

```
sudo orangepi-config
```

# boot from ssd
## analyse disks : 
```
sudo fdisk -l
```

## clear nvme0n1:
```
sudo gdisk /dev/nvme0n1
```
delete partition if necessary with :
(d) / <partition number>

## clear mtdblock0 (same as before)
```
sudo gdisk /dev/mtdblock0
```

## Transferring the OS image over to the M.2 SSD
 same as :  ‘sudo orangepi-config’ and choosing System –> Install.
```
sudo nand-sata-install
```
choose : <7>
then verify mtdblock0 has some partitions in it

# Install the system on the ssd : 
## copy the image file with scp :
```
scp ~/Downloads/Orangepi5pro_1.0.6_ubuntu_jammy_server_linux6.1.43/Orangepi5pro_1.0.6_ubuntu_jammy_server_linux6.1.43.img orangepi@node01:~/ubuntu.img
```

## hard copy to the ssd (speed about 65MB/s - redo it if higher !!): 
```
sudo dd bs=1M if=ubuntu.img of=/dev/nvme0n1 status=progress
```

# halt and REMOVE SD CARD : 
```
sudo shutdown -h now
```

# Boot up with new image :

## verify nvmeOn1p2 and mmcblk1p 2UUIDs are NOT the same :
```
sudo blkid
```
### if they are, use : 
```
sudo tune2fs -U random /dev/mmcblk1p2
```

# setup the system again

# OR flash ssd with ubuntu os directly and :

## orangepi-config
configure : 
- system/zsh
- personal/timezone
- personal/keyboard
- personal/hostname <- node name ? 

```
sudo orangepi-config
```
## installation
apt-get install fail2ban

## add ansible user
useradd ansible
mkdir /home/ansible
mkdir /home/ansible/.ssh
chmod 700 /home/ansible/.ssh