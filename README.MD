# kmod-ceph
build libceph and ceph kernel module

# prepare build kernel module
## deps
deps on centos: kernel kernel-headers kernel-devel
## prepare build
```
wget http://vault.centos.org/7.4.1708/os/Source/SPackages/kernel-3.10.0-693.el7.src.rpm
rpm -ihv kernel-3.10.0-693.el7.src.rpm
cd ~/rpmbuild/SOURCES
tar Jxf linux-3.10.0-693.el7.tar.xz
cd linux-3.10.0-693.el7
#modify Makefile this line: EXTRAVERSION = -693.21.1.el7.x86_64
make mrproper
cp /usr/src/kernels/$(uname -r)/Module.symvers .
cp /boot/config-$(uname -r) .config
make oldconfig
make prepare
make modules_prepare
make scripts
```
## build ceph module
```
bash pkg.sh [version]
```

# refs
- [Build Your Own Kernel Modules](https://wiki.centos.org/HowTos/BuildingKernelModules)
- [kernel module compile](https://blog.csdn.net/hedongho/article/details/79705563)

