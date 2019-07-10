#!/bin/bash
# Copyright 2019 Rendition Infosec
# Licensed under GPL
# Run this at your own risk, we're not responsible for what you do as root...
# Builds a centos profile and outputs it to the directory specified (default /tmp)

outdir="$1"
if [ -z $outdir ]; then
	outdir=/tmp
fi

yum install unzip -y
yum install kernel-devel -y
yum install "kernel-devel-uname-r == $(uname -r)" -y
yum install "kernel-headers-uname-r == $(uname -r)" -y
yum install gcc -y 
yum install zip -y
yum install libdwarf-tools -y

# grab the volatility distribution
curl -L http://downloads.volatilityfoundation.org/releases/2.6/volatility-2.6.zip > volatility-2.6.zip

# unzip 
unzip  volatility-2.6.zip volatility-master/tools/linux/*

# make the profile
pushd volatility-master/tools/linux/
make
zip profile-`uname -r`.zip module.dwarf /boot/System.map-`uname -r`
mv profile-`uname -r`.zip $outdir
popd
rm -rf volatility-2.6.zip volatility-master/tools/linux/*

