#!/bin/bash

case "${1}" in
pal-dvd)
  XRES=720
  YRES=576
  RATE=25
  CSPACE="bt601-6-625"
  CMATRIX="bt470bg"
  CTRC="gamma28"
  PAL='-p'
  REGION=PAL
  ;;
ntsc-dvd)
  XRES=720
  YRES=480
  RATE="30000/1001"
  CSPACE="bt601-6-525"
  CMATRIX="smpte170m"
  CTRC="smpte170m"
  PAL=''
  REGION=NTSC
  ;;
*)
  echo "No format supplied"
  exit 1
  ;;
esac

./build_images.sh "${1}"
./build_vob.sh "${1}"
./build_iso.sh "${1}"

