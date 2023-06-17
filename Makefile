
# 创建的包的文件名
PACKAGE=ubuntu_20.04_imx8mm_rootfs

# 软件包的下载路径
DOWNLOAD=http://cdimage.ubuntu.com/ubuntu-base/releases/20.04.5/release/ubuntu-base-20.04.5-base-arm64.tar.gz

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
