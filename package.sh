#!/bin/bash
###
 # @Author: lqm283
 # @Date: 2021-03-25 10:57:17
 # @LastEditTime: 2022-03-07 17:18:28
 # @LastEditors: lqm283
 # @Description: In User Settings Edit
 # @FilePath: /rootfs_make/package.sh
###

MAKE_DIR=$1


if [ ! $MAKE_DIR ]; then
    echo "Please use 'make package' to build file system!"
    exit 1
fi

# 要生成的根文件系统文件
ROOTFS=$MAKE_DIR.ext4


# 创建ext4文件,根据根文件系统的大小分配ext4文件的大小。
num=$(sudo du -sh $MAKE_DIR/ | cut -f1)
for var in $num
do
  num=${var%M}
done
let num=num+200
num=${num}M
echo $num
dd if=/dev/zero of=$ROOTFS bs=$num count=1
sudo mkfs.ext4  $ROOTFS

# 将文件系统写入到ext4文件中
mkdir -p rootfs_tmp
sudo mount -o loop $ROOTFS ./rootfs_tmp
sudo tar xvf $MAKE_DIR.tar.bz2  -C   ./rootfs_tmp
sudo umount ./rootfs_tmp

# 清理临时文件
sudo rm -rf ./rootfs_tmp
sudo rm -rf $MAKE_DIR

echo "Build file system complete!"
du -sh $MAKE_DIR.ext4
du -sh $MAKE_DIR.tar.bz2
