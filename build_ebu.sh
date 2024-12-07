#!/bin/bash

## Image sequence builder for SD/Rec.601 colour calibration
## Designed for use with ColorHCFR software
## Builds 8 bit per channel sRGB images (same white/chromacity co-ordinates as Rec.709)
## Later, ffmpeg will convert these to Rec.601 525 (NTSC) or 625 (PAL/SECAM) colour space
## Expects a format passed that matches ffmpeg's "-target"
## i.e.: either pal-dvd or ntsc-dvd

## This expects ImageMagick installed, and the commands "convert" and "montage" in $PATH

# Set resolutions for disc formats based on video/broadcast/SMPTE standards

case "${1}" in
pal-dvd)
  XRES=720
  YRES=576
  RATE=25
  ;;
ntsc-dvd)
  XRES=720
  YRES=480
  RATE="30000/1001"
  ;;
*)
  echo "No format supplied"
  exit 1
  ;;
esac

# ImageMagick colorspace "sRGB" for base RGB calculations of images
# TIFF format preserves colorspace across compositing tasks
I="magick -colorspace sRGB -type truecolor -depth 8"
M="magick montage +set label -colorspace sRGB -type truecolor -depth 8"
DL="${I} -gravity NorthEast -background black -fill gray -pointsize 30 -annotate +10+35"
DR="${I} -gravity NorthWest -background black -fill gray -pointsize 30 -annotate +10+35"

# Set our chunk sizes and final resolutions
CXRES=$(( ${XRES}/8 ))
CYRES=${YRES}
CRES="${CXRES}x${CYRES}"
RES="${XRES}x${YRES}"

OD="out/${1}/ebu"
mkdir ${OD} >/dev/null 2>&1

echo "Building EBU chunks..."

## Create the chunks needed for later

## 100% EBU
$I -size "${CRES}" xc:"rgb(255,255,255)"  ${OD}/chunk_ebu_100_white.tif
$I -size "${CRES}" xc:"rgb(255,255,0)"    ${OD}/chunk_ebu_100_yellow.tif
$I -size "${CRES}" xc:"rgb(0,255,255)"    ${OD}/chunk_ebu_100_cyan.tif
$I -size "${CRES}" xc:"rgb(0,255,0)"      ${OD}/chunk_ebu_100_green.tif
$I -size "${CRES}" xc:"rgb(255,0,255)"    ${OD}/chunk_ebu_100_magenta.tif
$I -size "${CRES}" xc:"rgb(255,0,0)"      ${OD}/chunk_ebu_100_red.tif
$I -size "${CRES}" xc:"rgb(0,0,255)"      ${OD}/chunk_ebu_100_blue.tif
$I -size "${CRES}" xc:"rgb(0,0,0)"        ${OD}/chunk_ebu_100_black.tif

## 75% EBU
$I -size "${CRES}" xc:"rgb(191,191,191)"  ${OD}/chunk_ebu_075_white.tif
$I -size "${CRES}" xc:"rgb(191,191,0)"    ${OD}/chunk_ebu_075_yellow.tif
$I -size "${CRES}" xc:"rgb(0,191,191)"    ${OD}/chunk_ebu_075_cyan.tif
$I -size "${CRES}" xc:"rgb(0,191,0)"      ${OD}/chunk_ebu_075_green.tif
$I -size "${CRES}" xc:"rgb(191,0,191)"    ${OD}/chunk_ebu_075_magenta.tif
$I -size "${CRES}" xc:"rgb(191,0,0)"      ${OD}/chunk_ebu_075_red.tif
$I -size "${CRES}" xc:"rgb(0,0,191)"      ${OD}/chunk_ebu_075_blue.tif
$I -size "${CRES}" xc:"rgb(0,0,0)"        ${OD}/chunk_ebu_075_black.tif

## Create final composited images
for INTENSITY in 075 100
do
  $M -size "${RES}" \
    ${OD}/chunk_ebu_${INTENSITY}_white.tif    ${OD}/chunk_ebu_${INTENSITY}_yellow.tif \
    ${OD}/chunk_ebu_${INTENSITY}_cyan.tif     ${OD}/chunk_ebu_${INTENSITY}_green.tif  \
    ${OD}/chunk_ebu_${INTENSITY}_magenta.tif  ${OD}/chunk_ebu_${INTENSITY}_red.tif    \
    ${OD}/chunk_ebu_${INTENSITY}_blue.tif     ${OD}/chunk_ebu_${INTENSITY}_black.tif  \
    -tile 8x1 -geometry +0+0 ${OD}/comp_ebu_${INTENSITY}.tif
done

