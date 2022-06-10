#!/bin/bash
###
 # @Author: lqm283
 # @Date: 2021-03-25 10:57:17
 # @LastEditTime: 2022-03-07 17:18:45
 # @LastEditors: lqm283
 # @Description: In User Settings Edit
 # @FilePath: /rootfs_make/mkfs.sh
###

MAKE_DIR=$1
DOWNLOAD=$2
BASE_FILE=$3


if [ ! $MAKE_DIR ] || [ ! $DOWNLOAD ] || [ ! $BASE_FILE ]; then
    echo "Please use 'make' to build file system!"
    exit 1
fi


# 要生成的根文件系统文件
ROOTFS=$MAKE_DIR.ext4

# 清理之前生成的根文件系统创建目录
if [  -d "$MAKE_DIR" ];then
    echo "The build dir is exist,remove it before building..."
    sudo rm -rf $MAKE_DIR
fi

echo "Make a new build dir..."
mkdir $MAKE_DIR


if [ ! -f "./download/$BASE_FILE" ];then
  echo "Base rootfs is not exist,downloading..."
  wget -P ./download $DOWNLOAD
else
  echo "Base rootfs is exist..."
fi

echo "Unzip the base rootfs..."
tar -xvf ./download/$BASE_FILE -C $MAKE_DIR
echo "Unzip complete..."
echo ""

QEMU=$(which qemu-arm-static) || { echo y|apt update && echo y|apt upgrade && echo y|apt install qemu-user-static; }

echo "Copy the qemu to rootfs building dir."
sudo cp $QEMU $MAKE_DIR/usr/bin
echo "Copy over!"
echo ""

#修改源
sed -i 's/ports\.ubuntu\.com/mirrors\.ustc\.edu\.cn/g' $MAKE_DIR/etc/apt/sources.list

#复制本机的DNS配置文件到相应根文件系统目录
cp /etc/resolv.conf $MAKE_DIR/etc/resolv.conf

#安装go
echo "installing go"
# sudo tar -C $MAKE_DIR/usr/local -xzf go1.17.1.linux-armv6l.tar.gz

#安装redis

#加入关闭看门狗的执行脚本并添加可执行属性
# sudo cp ./script/systemset.sh $MAKE_DIR/usr/bin/
# sudo chmod +x $MAKE_DIR/usr/bin/systemset.sh

#加入关闭看门狗的开机启动服务程序
# sudo cp ./script/systemset.service $MAKE_DIR/lib/systemd/system/


#挂载并切换到Ubuntu roofs
sudo cp ./script/set.sh $MAKE_DIR/bin
sudo chmod +x $MAKE_DIR/bin/set.sh
sudo ./script/mount.sh  -m  $MAKE_DIR/

#卸载之前的挂载
sudo ./script/mount.sh  -u  ./$MAKE_DIR/

#将网络配置文件复制到/etc/netplan/目录下
sudo cp ./script/00-installer-config.yaml $MAKE_DIR/etc/netplan/

#打包根文件系统
cd $MAKE_DIR && sudo tar -cjvf ../$MAKE_DIR.tar.bz2 .
cd ..


# 创建ext4文件,根据根文件系统的大小分配ext4文件的大小。
num=$(sudo du -sm $MAKE_DIR/ | cut -f1)
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
