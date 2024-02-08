# NixOS NAS

Why buy an overpriced [NAS](https://en.wikipedia.org/wiki/Network-attached_storage), install [FreeNAS](https://freenas.org/) or [Rockstor](http://rockstor.com/) when you can setup [Samba](https://www.samba.org/) with few lines of [NixOS](http://nixos.org/) config?

Other features can easily be added.

## Features

- SMB Shares
- Amazon S3 compatible Object Storage ([Minio](https://www.minio.io/))
- Syncthing
- IPFS
- Docker containers
- BOINC (distributed computing)
- Monitoring storage devices via [S.M.A.R.T.](https://en.wikipedia.org/wiki/S.M.A.R.T.) with email notification
- Monitoring with [netdata](https://my-netdata.io/) and [vnStat](http://humdi.net/vnstat/)

## Tips and Tricks

- enable [AHCI](https://en.wikipedia.org/wiki/Advanced_Host_Controller_Interface) in your BIOS to have hot swap support

## Install

Follow the generic install manual at [nixos.org](http://nixos.org/nixos/manual/index.html#ch-installation) or on [my website](https://davidak.de/nixos-installation/) in german.

Then follow this instructions to setup your NAS:

```
imac:code davidak$ rsync -ahz --progress nixos root@nas.lan:

[root@nixos:~]# rm /etc/nixos/configuration.nix
[root@nixos:~]# ln -s /root/nixos/nas/configuration.nix /etc/nixos/configuration.nix
[root@nixos:~]# nixos-rebuild switch

[root@NAS:~]# mkfs.btrfs -d raid1 -m raid1 -L data /dev/sdb /dev/sdc
mkdir /data
mount /dev/disk/by-label/data /data
# include mountpoint in hardware config.
nixos-generate-config

btrfs subvolume create /data/media
btrfs subvolume create /data/archiv
btrfs subvolume create /data/backup
btrfs subvolume create /data/upload
btrfs subvolume create /data/snapshots
btrfs subvolume create /data/minio

mkdir /data/snapshots/{archiv,backup,media,minio,upload}
chown davidak:users -R /data/*
chmod -R 777 /data/upload/

smbpasswd -a davidak
passwd davidak
```

Start Minecraft docker container:

```
docker run --name spigot -d -v /var/lib/spigot:/minecraft -p 25565:25565 -p 8123:8123 -e EULA=true -e SPIGOT_VER=1.11.2 -e MC_MINMEM=512m -e MC_MAXMEM=4g -e SPIGOT_AUTORESTART=no nimmis/spigot
```

## Configure

To be able to access Syncthing from your local network, you have to edit `/var/lib/syncthing/config.xml`:

```
<address>0.0.0.0:8384</address>
```

Add user and password in the webinterface to secure your data!

## Maintenance

### show filesystem usage

```
[root@nas:~]# btrfs fi usage -T /data/
Overall:
    Device size:		  14.55TiB
    Device allocated:		   9.47TiB
    Device unallocated:		   5.09TiB
    Device missing:		     0.00B
    Used:			   9.22TiB
    Free (estimated):		   2.67TiB	(min: 2.67TiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

            Data    Metadata System
Id Path     RAID1   RAID1    RAID1     Unallocated
-- -------- ------- -------- --------- -----------
 1 /dev/sdb 4.72TiB 10.00GiB   8.00MiB     2.54TiB
 2 /dev/sdc 4.72TiB 10.00GiB   8.00MiB     2.54TiB
-- -------- ------- -------- --------- -----------
   Total    4.72TiB 10.00GiB   8.00MiB     5.09TiB
   Used     4.60TiB  7.73GiB 688.00KiB
```

### show drive errors

```
[root@nas:~]# btrfs device stats /data
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 0
[/dev/sdc].generation_errs 0
```

### create snapshot

```
[root@nixos:~]# btrfs subvolume snapshot -r /data/upload /data/snapshots/upload/$(date -I)
Create a readonly snapshot of '/data/upload' in '/data/snapshots/upload/2017-07-31'
```

or for every subvolume at once

```
[root@nas:~]# for i in archiv backup media minio upload; do btrfs subvolume snapshot -r /data/$i /data/snapshots/$i/$(date -I); done
Create a readonly snapshot of '/data/archiv' in '/data/snapshots/archiv/2017-07-31'
Create a readonly snapshot of '/data/backup' in '/data/snapshots/backup/2017-07-31'
Create a readonly snapshot of '/data/media' in '/data/snapshots/media/2017-07-31'
Create a readonly snapshot of '/data/minio' in '/data/snapshots/minio/2017-07-31'
Create a readonly snapshot of '/data/upload' in '/data/snapshots/upload/2017-07-31'
```

### remove snapshots

List the snapshots:

```
[root@nas:~]# btrfs subvolume list -s /data/
ID 5162 gen 9413 cgen 9413 top level 5161 otime 2017-07-31 08:33:04 path snapshots/archiv/2017-07-31
ID 5163 gen 9414 cgen 9414 top level 5161 otime 2017-07-31 08:33:05 path snapshots/backup/2017-07-31
ID 5164 gen 9415 cgen 9415 top level 5161 otime 2017-07-31 08:33:05 path snapshots/media/2017-07-31
ID 5165 gen 9416 cgen 9416 top level 5161 otime 2017-07-31 08:33:07 path snapshots/upload/2017-07-31
```

With [btrfs-du](https://github.com/nachoparker/btrfs-du/) you can see how much space the snapshots use:

```
[root@nas:~]# ./btrfs-du /data
INFO: Quota is disabled. Waiting for rescan to finish ...
Subvolume                                                         Total  Exclusive  ID        
─────────────────────────────────────────────────────────────────────────────────────────
media                                                           2.57TiB  712.63GiB  258       
archiv                                                          1.86TiB    1.86TiB  259       
backup                                                        434.26GiB  434.26GiB  260       
upload                                                          8.12MiB    8.08MiB  261       
snapshots                                                      16.00KiB   16.00KiB  5161      
snapshots/backup/2017-07-31                                    16.00KiB   16.00KiB  5163      
snapshots/media/2017-07-31                                      1.91TiB   42.15GiB  5164      
snapshots/upload/2017-07-31                                    64.00KiB   16.00KiB  5165      
minio                                                         835.97GiB  835.97GiB  5353      
─────────────────────────────────────────────────────────────────────────────────────────
Total exclusive data                                                            3.84TiB
```

Then delete every snapshot you don't need anymore:

```
[root@nas:~]# btrfs subvolume delete /data/snapshots/archiv/2017-07-31
Delete subvolume (no-commit): '/data/snapshots/archiv/2017-07-31'
```

### Add new disks to filesystem

Look for name of new disks. Run this command before and after you added them:

```
fdisk -l
```

Add the disks to the filesystem:

```
[root@nas:~]# btrfs device add /dev/sdd /data/

[root@nas:~]# btrfs device add /dev/sde /data/

[root@nas:~]# btrfs filesystem show
Label: 'data'  uuid: 0cb33817-6ee2-41e4-8531-89c08b5a7327
	Total devices 4 FS bytes used 6.71TiB
	devid    1 size 7.28TiB used 6.71TiB path /dev/sdb
	devid    2 size 7.28TiB used 6.71TiB path /dev/sdc
	devid    3 size 10.91TiB used 0.00B path /dev/sdd
	devid    4 size 10.91TiB used 0.00B path /dev/sde
```

## Resources

- [Centos 7 with BTRFS and snapshots](https://www.mopar4life.com/btrfs-centos-samba/)
- [The perfect Btrfs setup for a server](https://seravo.fi/2016/perfect-btrfs-setup-for-a-server)
- [Using RAID with btrfs and recovering from broken disks](https://seravo.fi/2015/using-raid-btrfs-recovering-broken-disks)
- [Arch Linux Wiki: Btrfs](https://wiki.archlinux.org/index.php/Btrfs)
