
# 创建的包的文件名
# PACKAGE=ubuntu_16.04_stm32mp1_rootfs
#PACKAGE=ubuntu_18.04_stm32mp1_rootfs
PACKAGE=ubuntu_20.04_stm32mp1_rootfs

# 软件包的下载路径
# DOWNLOAD=http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.6/release/ubuntu-base-16.04.6-base-armhf.tar.gz
# DOWNLOAD=http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.5/release/ubuntu-base-18.04.5-base-armhf.tar.gz
DOWNLOAD=http://cdimage.ubuntu.com/ubuntu-base/releases/20.04.4/release/ubuntu-base-20.04.4-base-armhf.tar.gz

FILE=$(notdir $(DOWNLOAD))


all:download clean
	sudo ./mkfs.sh $(PACKAGE) $(DOWNLOAD) $(FILE)

download:
	mkdir -p $@

clean:
	sudo rm -rf $(PACKAGE)*

distclean: clean
	rm -rf download

package:
	sudo ./package.sh $(PACKAGE)
