#!/bin/sh
#
# This scripts creates the isolinux directory for using in salix iso.


if [ "$UID" -eq "0" ]; then
	echo "Don't run this script as root"
	exit 1
fi

set -e

if [ ! -f EDITION ]; then
	echo "No edition file."
	exit 1
else
	edition=`cat EDITION`
fi

if [ ! -f ARCH ]; then
	echo "No ARCH file."
	exit 1
else
	arch=`cat ARCH`
fi

if [ ! -f VERSION ]; then
	echo "No VERSION file."
	exit 1
else
	ver=`cat VERSION`
fi

# FIXME
#
# This is temporary. When slackware releases 14.2, remove this line:
ver=current

rm -rf isolinux/$arch
mkdir -p isolinux/$arch

# copy the isolinux.bin from the system (it's exactly the same for both
# architectures). For some reason slackware uses the
# isolinux-debug.bin, which prevents making a hybrid iso
#cp /usr/share/syslinux/isolinux.bin isolinux/$arch
(
  cd isolinux/$arch
  wget ftp://ftp.slackware.uk/slackware/slackware64-$ver/isolinux/isolinux.bin
)

# copy the initrd (it should already be there)
cp initrd/$arch/*.img isolinux/$arch/

# copy the rest of the files
cp isolinux-files/$arch/* isolinux/$arch/

# write the edition in the messages.txt file
sed -i "s/__EDITION__/$edition/" isolinux/$arch/message.txt
echo "DONE!"

set +e
