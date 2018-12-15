#!/bin/bash
set -e
version=${1:-0.0.3}
ksrc=${2:-/root/rpmbuild/SOURCES/linux-3.10.0-693.el7}
[[ ! -d $ksrc ]] && { echo src $ksrc NOT FOUND; exit 1; }
spec=ceph-kmod.spec
[[ ! -f ${spec}.in ]] && { echo spec file NOT FOUND; exit 1; }

prepare(){
	name=$1
	path=$2
	echo "prepare $name src files ..."
	/bin/rm -rf $name
	/bin/mkdir -p $name
	/bin/cp -a $path/* $name
	/bin/tar -jcf $name.tar.bz2 $name --remove-files
	srcdir=$(rpmbuild -E %_sourcedir)
	/bin/mkdir -p $srcdir
	/bin/mv $name.tar.bz2 $srcdir
}

prepare ceph-${version} ceph
prepare libceph-${version} libceph

specdir=$(/bin/rpmbuild -E %_specdir)
/bin/mkdir -p $specdir
cat ${spec}.in |
        sed "s|@VERSION@|$version|g" |
        sed "s|@KERNEL_SOURCE@|$ksrc|g" > ${specdir}/${spec}

pushd ${specdir}
/bin/rpmbuild -ba --target=`uname -m` ${spec} 2> build-err.log | tee build-out.log
popd

rp=$(ls $(/bin/rpmbuild -E %_rpmdir)/$(uname -m)/kmod-ceph-${version}*)
if [ ! -z $rp ];then
	echo "build $rp done"
fi

