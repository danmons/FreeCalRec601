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

I="convert -colorspace sRGB -type truecolor -depth 8"
M="montage +set label -colorspace sRGB -type truecolor -depth 8"
D="${I} -gravity NorthEast -background black -fill gray -pointsize 30 -annotate +10+10"

# Set our chunk sizes and final resolutions
CXRES=$(( ${XRES}/4 ))
CYRES=$(( ${YRES}/4 ))
CRES="${CXRES}x${CYRES}"
RES="${XRES}x${YRES}"

mkdir ${1} >/dev/null 2>&1

echo "Building image chunks..."

## Create the chunks needed for later
## We want the test pattern to be have a black border to prevent excess brightness and geometry distortions
## Colour ratios taken from ColorHCFR in 0-255 (full range RGB) mode
# Solid colours
$I -size "${CRES}" xc:"rgb(0,0,0)"        ${1}/chunk_black.tif
$D "0,0,0" ${1}/chunk_black.tif ${1}/desc_black.tif

$I -size "${CRES}" xc:"rgb(255,255,255)"  ${1}/chunk_white.tif
$D "255,255,255" ${1}/chunk_black.tif ${1}/desc_white.tif

$I -size "${CRES}" xc:"rgb(255,0,0)"      ${1}/chunk_red.tif
$D "255,0,0" ${1}/chunk_black.tif ${1}/desc_red.tif

$I -size "${CRES}" xc:"rgb(0,255,0)"      ${1}/chunk_green.tif
$D "0,255,0" ${1}/chunk_black.tif ${1}/desc_green.tif

$I -size "${CRES}" xc:"rgb(0,0,255)"      ${1}/chunk_blue.tif
$D "0,0,255" ${1}/chunk_black.tif ${1}/desc_blue.tif

$I -size "${CRES}" xc:"rgb(0,255,255)"    ${1}/chunk_cyan.tif
$D "0,255,255" ${1}/chunk_black.tif ${1}/desc_cyan.tif

$I -size "${CRES}" xc:"rgb(255,0,255)"    ${1}/chunk_magenta.tif
$D "255,0,255" ${1}/chunk_black.tif ${1}/desc_magenta.tif

$I -size "${CRES}" xc:"rgb(255,255,0)"    ${1}/chunk_yellow.tif
$D "255,255,0" ${1}/chunk_black.tif ${1}/desc_yellow.tif

# Grey scale
$I -size "${CRES}" xc:"rgb(26,26,26)"     ${1}/chunk_grey10.tif
$D "26,26,26" ${1}/chunk_black.tif ${1}/desc_grey10.tif

$I -size "${CRES}" xc:"rgb(51,51,51)"     ${1}/chunk_grey20.tif
$D "51,51,51" ${1}/chunk_black.tif ${1}/desc_grey20.tif

$I -size "${CRES}" xc:"rgb(77,77,77)"     ${1}/chunk_grey30.tif
$D "77,77,77" ${1}/chunk_black.tif ${1}/desc_grey30.tif

$I -size "${CRES}" xc:"rgb(102,102,102)"  ${1}/chunk_grey40.tif
$D "102,102,102" ${1}/chunk_black.tif ${1}/desc_grey40.tif

$I -size "${CRES}" xc:"rgb(128,128,128)"  ${1}/chunk_grey50.tif
$D "128,128,128" ${1}/chunk_black.tif ${1}/desc_grey50.tif

$I -size "${CRES}" xc:"rgb(153,153,153)"  ${1}/chunk_grey60.tif
$D "153,153,153" ${1}/chunk_black.tif ${1}/desc_grey60.tif

$I -size "${CRES}" xc:"rgb(178,178,178)"  ${1}/chunk_grey70.tif
$D "178,178,178" ${1}/chunk_black.tif ${1}/desc_grey70.tif

$I -size "${CRES}" xc:"rgb(204,204,204)"  ${1}/chunk_grey80.tif
$D "204,204,204" ${1}/chunk_black.tif ${1}/desc_grey80.tif

$I -size "${CRES}" xc:"rgb(229,229,229)"  ${1}/chunk_grey90.tif
$D "229,229,229" ${1}/chunk_black.tif ${1}/desc_grey90.tif

# Red saturations
$I -size "${CRES}" xc:"rgb(127,127,127)"  ${1}/chunk_red00.tif
$D "127,127,127" ${1}/chunk_black.tif ${1}/desc_red00.tif

$I -size "${CRES}" xc:"rgb(171,112,112)"  ${1}/chunk_red25.tif
$D "171,112,112" ${1}/chunk_black.tif ${1}/desc_red25.tif

$I -size "${CRES}" xc:"rgb(204,93,93)"    ${1}/chunk_red50.tif
$D "204,93,93" ${1}/chunk_black.tif ${1}/desc_red50.tif

$I -size "${CRES}" xc:"rgb(231,68,68)"    ${1}/chunk_red75.tif
$D "231,68,68" ${1}/chunk_black.tif ${1}/desc_red75.tif

# Green saturations
$I -size "${CRES}" xc:"rgb(219,219,219)"  ${1}/chunk_green00.tif
$D "219,219,219" ${1}/chunk_black.tif ${1}/desc_green00.tif

$I -size "${CRES}" xc:"rgb(177,234,177)"  ${1}/chunk_green25.tif
$D "177,234,177" ${1}/chunk_black.tif ${1}/desc_green25.tif

$I -size "${CRES}" xc:"rgb(137,243,137)"  ${1}/chunk_green50.tif
$D "137,243,137" ${1}/chunk_black.tif ${1}/desc_green50.tif

$I -size "${CRES}" xc:"rgb(94,250,94)"    ${1}/chunk_green75.tif
$D "rgb(94,250,94" ${1}/chunk_black.tif ${1}/desc_green75.tif

# Blue saturations
$I -size "${CRES}" xc:"rgb(78,78,78)"     ${1}/chunk_blue00.tif
$D "78,78,78" ${1}/chunk_black.tif ${1}/desc_blue00.tif

$I -size "${CRES}" xc:"rgb(76,78,100)"    ${1}/chunk_blue25.tif
$D "76,78,100" ${1}/chunk_black.tif ${1}/desc_blue25.tif

$I -size "${CRES}" xc:"rgb(72,72,128)"    ${1}/chunk_blue50.tif
$D "72,72,128" ${1}/chunk_black.tif ${1}/desc_blue50.tif

$I -size "${CRES}" xc:"rgb(64,64,169)"    ${1}/chunk_blue75.tif
$D "64,64,169" ${1}/chunk_black.tif ${1}/desc_blue75.tif

# Yellow saturations
$I -size "${CRES}" xc:"rgb(247,247,247)"  ${1}/chunk_yellow00.tif
$D "247,247,247" ${1}/chunk_black.tif ${1}/desc_yellow00.tif

$I -size "${CRES}" xc:"rgb(249,249,205)"  ${1}/chunk_yellow25.tif
$D "249,249,205" ${1}/chunk_black.tif ${1}/desc_yellow25.tif

$I -size "${CRES}" xc:"rgb(252,252,162)"  ${1}/chunk_yellow50.tif
$D "252,252,162" ${1}/chunk_black.tif ${1}/desc_yellow50.tif

$I -size "${CRES}" xc:"rgb(254,254,113)"  ${1}/chunk_yellow75.tif
$D "254,254,113" ${1}/chunk_black.tif ${1}/desc_yellow75.tif

# Cyan Saturations
$I -size "${CRES}" xc:"rgb(229,229,229)"  ${1}/chunk_cyan00.tif
$D "229,229,229" ${1}/chunk_black.tif ${1}/desc_cyan00.tif

$I -size "${CRES}" xc:"rgb(201,236,236)"  ${1}/chunk_cyan25.tif
$D "201,236,236" ${1}/chunk_black.tif ${1}/desc_cyan25.tif

$I -size "${CRES}" xc:"rgb(168,242,242)"  ${1}/chunk_cyan50.tif
$D "168,242,242" ${1}/chunk_black.tif ${1}/desc_cyan50.tif

$I -size "${CRES}" xc:"rgb(122,249,249)"  ${1}/chunk_cyan75.tif
$D "122,249,249" ${1}/chunk_black.tif ${1}/desc_cyan75.tif

# Magenta Saturations
$I -size "${CRES}" xc:"rgb(144,144,144)"  ${1}/chunk_magenta00.tif
$D "144,144,144" ${1}/chunk_black.tif ${1}/desc_magenta00.tif

$I -size "${CRES}" xc:"rgb(165,136,165)"  ${1}/chunk_magenta25.tif
$D "165,136,165" ${1}/chunk_black.tif ${1}/desc_magenta25.tif

$I -size "${CRES}" xc:"rgb(189,122,189)"  ${1}/chunk_magenta50.tif
$D "189,122,189" ${1}/chunk_black.tif ${1}/desc_magenta50.tif

$I -size "${CRES}" xc:"rgb(218,98,218)"   ${1}/chunk_magenta75.tif
$D "218,98,218" ${1}/chunk_black.tif ${1}/desc_magenta75.tif

echo "Compositing images..."

## Create final composited images
## Black border to prevent full screen brightness interfering with geometry or colour
ls -1d ${1}/chunk_*.tif | while read FILE
do
  FILENAME=$(basename "${FILE}")
  FILENAME="${FILENAME%.*}"
  COLOUR=$( echo $FILENAME | awk -F '_' '{print $2}' )
  echo "Compositing ${COLOUR}..."
  $M -size "${RES}" \
    ${1}/chunk_black.tif ${1}/chunk_black.tif ${1}/chunk_black.tif ${1}/chunk_black.tif \
    ${1}/chunk_black.tif ${1}/chunk_${COLOUR}.tif ${1}/chunk_${COLOUR}.tif ${1}/chunk_black.tif \
    ${1}/chunk_black.tif ${1}/chunk_${COLOUR}.tif ${1}/chunk_${COLOUR}.tif ${1}/chunk_black.tif \
    ${1}/chunk_black.tif ${1}/desc_${COLOUR}.tif ${1}/chunk_black.tif ${1}/chunk_black.tif \
    -tile 4x4 -geometry +0+0 ${1}/comp_${COLOUR}.tif
done

echo "Building DVD menus..."

BXRES=200
BYRES=100

for WORD in Greyscale Colours Saturation
do
  $I -size ${BXRES}x${BYRES} -background black -pointsize 40 -gravity center -fill white label:${WORD} ${1}/menu_${WORD}.tif
done

$M \
  ${1}/menu_Greyscale.tif ${1}/menu_Colours.tif ${1}/menu_Saturation.tif \
  -tile 1x3 -geometry +0+0 ${1}/menu_comp_small.tif

$I ${1}/menu_comp_small.tif -background black -gravity center -extent ${RES} ${1}/menu_comp_large.tif


## Transparency not working in spumux, try this another day
YTL1=$(( ${YRES}/2-50-100 ))
YTL2=$(( ${YRES}/2-50 ))
YTL3=$(( ${YRES}/2+50 ))
YBR1=$(( ${YRES}/2-50 ))
YBR2=$(( ${YRES}/2+50 ))
YBR3=$(( ${YRES}/2+50+100 ))
XTL=$(( ${XRES}/2-100 ))
XBR=$(( ${XRES}/2+100 ))

convert +antialias -size ${RES} xc:none -fill none -strokewidth 5 -stroke yellow \
  -draw "roundrectangle ${XTL},${YTL1} ${XBR},${YBR1} 20,20" \
  -draw "roundrectangle ${XTL},${YTL2} ${XBR},${YBR2} 20,20" \
  -draw "roundrectangle ${XTL},${YTL3} ${XBR},${YBR3} 20,20" \
  -colors 4 -alpha on ${1}/menu_buttons.png

#MXRES=$(( ${XRES}/4 ))
#XCIRC=$(( ${MXRES}/2 ))
#XCIRR=$(( ${MXRES}/2+10 ))
#YCIR1=$(( ${YRES}/2-75 ))
#YCIR2=$(( ${YRES}/2 ))
#YCIR3=$(( ${YRES}/2+75 ))

#convert +antialias -size ${MXRES}x${YRES} xc:none -fill yellow -stroke none \
#   -draw "circle ${XCIRC},${YCIR1} ${XCIRR},${YCIR1}" \
#   -draw "circle ${XCIRC},${YCIR2} ${XCIRR},${YCIR2}" \
#   -draw "circle ${XCIRC},${YCIR3} ${XCIRR},${YCIR3}" \
#  -colors 4 ${1}/menu_buttons.png

