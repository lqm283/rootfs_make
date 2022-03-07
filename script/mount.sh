mnt()
###
 # @Author: your name
 # @Date: 2021-03-25 09:23:38
 # @LastEditTime: 2021-04-14 21:14:29
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: /ubuntu/mount.sh
### 
{
    echo "MOUNTING"
    sudo mount -t proc /proc ${2}proc
    sudo mount -t sysfs /sys ${2}sys
    sudo mount -o bind /dev ${2}dev
    sudo mount -o bind /dev/pts ${2}dev/pts
    sudo chroot ${2} set.sh
}

umnt() {
    echo "UNMOUNTING"
    sudo umount ${2}proc
    sudo umount ${2}sys
    sudo umount ${2}dev/pts
    sudo umount ${2}dev
}

if [ "$1" = "-m" ] && [ -n "$2" ];
then
    mnt $1 $2
    echo "mnt -m pwd"
elif [ "$1" = "-u" ] && [ -n "$2" ];
then
    umnt $1 $2
    echo "mnt -u pwd"
else
    echo ""
    echo "Either 1'st, 2'nd or bothparameters were missing"
    echo ""
    echo "1'st parameter can be one ofthese: -m(mount) OR -u(umount)"
    echo "2'nd parameter is the full pathof rootfs directory(with trailing '/')"
    echo ""
    echo "For example: ch-mount -m/media/sdcard/"
    echo ""
    echo 1st parameter : ${1}
    echo 2nd parameter : ${2}
fi

