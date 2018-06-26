#!/bin/bash

indir=$1
firmware=$2

if [ "${firmware}" = "" ] || [ "${indir}" = "" ]; then
  echo "Usage: ${0} <indir> <firmware>"
  exit 1
fi

if [ -f "${firmware}" ]; then
  echo "error: ${firmware} file already exists"
  exit 1
fi

if [ ! -e "${indir}" ]; then
  echo "error: ${outdir} directory doesn't exist"
  exit 1
fi

cd ${indir}
if [ ! -f "header.sh" ] || [ ! -f "initramfs" ] || [ ! -f "builtin.tgz" ] || [ ! -f "AS10XXT.dtb" ] || [ ! -f "AS10XXTE.dtb" ] || [ ! -f "zImage" ]; then
  echo "error: files expected in indir: header.sh, initramfs, builtin.tgz, AS10XXT.dtb, AS10XXTE.dtb, zImage"
  exit 1
fi

# first we calc the checksums
# then we add the original firwmware build path
opath="\/asustor\/branch3_1_2018_06_13\/arm\/arm\/images\/"
md5sum initramfs > initramfs.md5sum
sed -i "s/initramfs/${opath}initramfs/" initramfs.md5sum
cksum initramfs > initramfs.cksum
sed -i "s/initramfs/${opath}initramfs/" initramfs.cksum
md5sum builtin.tgz > builtin.tgz.md5sum
sed -i "s/builtin.tgz/${opath}builtin.tgz/" builtin.tgz.md5sum
cksum builtin.tgz > builtin.tgz.cksum
sed -i "s/builtin.tgz/${opath}builtin.tgz/" builtin.tgz.cksum
md5sum AS10XXT.dtb > AS10XXT.dtb.md5sum
sed -i "s/AS10XXT.dtb/${opath}AS10XXT.dtb/" AS10XXT.dtb.md5sum
md5sum AS10XXTE.dtb > AS10XXTE.dtb.md5sum
sed -i "s/AS10XXTE.dtb/${opath}AS10XXTE.dtb/" AS10XXTE.dtb.md5sum
md5sum zImage > zImage.md5sum
sed -i "s/zImage/${opath}zImage/" zImage.md5sum

# tar it up
tar -cf body.tar initramfs initramfs.cksum initramfs.md5sum builtin.tgz builtin.tgz.cksum builtin.tgz.md5sum AS10XXT.dtb AS10XXT.dtb.md5sum AS10XXTE.dtb AS10XXTE.dtb.md5sum zImage zImage.md5sum

# and add a newline for some reason
printf '\n' >> body.tar

# and add the header
cat header.sh body.tar > ../${firmware}
#cd ..
