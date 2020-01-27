# Mounting and unmounting

## Find mounted drives

$ findmnt
$ dmesg # see if the kernel detects the drive

Find the name if the drive in dmesg
That'll be in /dev
Mount thusly:
$ sudo mount /dev/sdb1 /media/kyle/BLADE

## Unmount drive

Use the mount point or name:
$ sudo umount /media/kyle/BLADE
