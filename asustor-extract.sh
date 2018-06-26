#!/bin/bash

firmware=$1
outdir=$2

if [ "${firmware}" = "" ] || [ "${outdir}" = "" ]; then
  echo "Usage: ${0} <firmware> <outdir>"
  exit 1
fi

if [ ! -f "${firmware}" ]; then
  echo "error: ${firmware} does not exist"
  exit 1
fi

if [ -e "${outdir}" ]; then
  echo "error: ${outdir} directory already exists"
  exit 1
fi

mkdir -p "${outdir}"

header_size=$(($(head -n20 ${firmware} | grep 'body_skip' | cut -d'=' -f2) - 1))
head -n${header_size} ${firmware} > ${outdir}/header.sh
offset=$(($(wc -c < ${outdir}/header.sh)))

dd if=${firmware} of=${outdir}/body.tar ibs=${offset} skip=1
cd ${outdir}
tar -xf body.tar
#rm body.tar
#cd ..
