#!/bin/bash

## Image sequence builder for SD/Rec.601 colour calibration
## Designed for use with ColorHCFR software
## Expects a format passed that matches ffmpeg's "-target"
## i.e.: one of pal-vcd, pal-svcd, pal-dvd, ntsc-vcd, ntsc-svcd, ntsc-dvd

## Assumes "dvd-menu" is in $PATH.

# Set resolutions for disc formats based on video/broadcast/SMPTE standards

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
  LREGION=pal
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
  LREGION=ntsc
  ;;
*)
  echo "No format supplied"
  exit 1
  ;;
esac

DATESTAMP=$(cat datestamp.txt)

mkdir iso-${1} >/dev/null 2>&1
rm -rf iso-${1}/*
rm FreeCalRec601_${REGION}_${DATESTAMP}.iso

TODAY=$(date +%F)

## Create the DVD menu page
echo "Calling spumux..."
spumux -m dvd menu_${LREGION}.xml < ${1}/dvd_menu_nosound.vob > ${1}/menu_${LREGION}.vob

## Create the DVD file system
echo "Calling dvdauthor..."
dvdauthor -x dvd_${LREGION}.xml

## Build the DVD iso
echo "Calling mkisofs..."
mkisofs -V "FreeCalRec601${REGION}_${TODAY}" -dvd-video -udf -o FreeCalRec601_${REGION}_${DATESTAMP}.iso iso-${1}/dvd_fs/

