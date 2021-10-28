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
DL="${I} -gravity NorthEast -background black -fill gray -pointsize 30 -annotate +10+10"
DR="${I} -gravity NorthWest -background black -fill gray -pointsize 30 -annotate +10+10"

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
$DL "0,0,0" ${1}/chunk_black.tif ${1}/descl_black.tif
$DR "black" ${1}/chunk_black.tif ${1}/descr_black.tif

$I -size "${CRES}" xc:"rgb(255,255,255)"  ${1}/chunk_white.tif
$DL "255,255,255" ${1}/chunk_black.tif ${1}/descl_white.tif
$DR "white" ${1}/chunk_black.tif ${1}/descr_white.tif

$I -size "${CRES}" xc:"rgb(255,0,0)"      ${1}/chunk_red.tif
$DL "255,0,0" ${1}/chunk_black.tif ${1}/descl_red.tif
$DR "red" ${1}/chunk_black.tif ${1}/descr_red.tif

$I -size "${CRES}" xc:"rgb(0,255,0)"      ${1}/chunk_green.tif
$DL "0,255,0" ${1}/chunk_black.tif ${1}/descl_green.tif
$DR "green" ${1}/chunk_black.tif ${1}/descr_green.tif

$I -size "${CRES}" xc:"rgb(0,0,255)"      ${1}/chunk_blue.tif
$DL "0,0,255" ${1}/chunk_black.tif ${1}/descl_blue.tif
$DR "blue" ${1}/chunk_black.tif ${1}/descr_blue.tif

$I -size "${CRES}" xc:"rgb(0,255,255)"    ${1}/chunk_cyan.tif
$DL "0,255,255" ${1}/chunk_black.tif ${1}/descl_cyan.tif
$DR "cyan" ${1}/chunk_black.tif ${1}/descr_cyan.tif

$I -size "${CRES}" xc:"rgb(255,0,255)"    ${1}/chunk_magenta.tif
$DL "255,0,255" ${1}/chunk_black.tif ${1}/descl_magenta.tif
$DR "magenta" ${1}/chunk_black.tif ${1}/descr_magenta.tif

$I -size "${CRES}" xc:"rgb(255,255,0)"    ${1}/chunk_yellow.tif
$DL "255,255,0" ${1}/chunk_black.tif ${1}/descl_yellow.tif
$DR "yellow" ${1}/chunk_black.tif ${1}/descr_yellow.tif

# Grey scale
$I -size "${CRES}" xc:"rgb(26,26,26)"     ${1}/chunk_grey10.tif
$DL "26,26,26" ${1}/chunk_black.tif ${1}/descl_grey10.tif
$DR "grey10" ${1}/chunk_black.tif ${1}/descr_grey10.tif

$I -size "${CRES}" xc:"rgb(51,51,51)"     ${1}/chunk_grey20.tif
$DL "51,51,51" ${1}/chunk_black.tif ${1}/descl_grey20.tif
$DR "grey20" ${1}/chunk_black.tif ${1}/descr_grey20.tif

$I -size "${CRES}" xc:"rgb(77,77,77)"     ${1}/chunk_grey30.tif
$DL "77,77,77" ${1}/chunk_black.tif ${1}/descl_grey30.tif
$DR "grey30" ${1}/chunk_black.tif ${1}/descr_grey30.tif

$I -size "${CRES}" xc:"rgb(102,102,102)"  ${1}/chunk_grey40.tif
$DL "102,102,102" ${1}/chunk_black.tif ${1}/descl_grey40.tif
$DR "grey40" ${1}/chunk_black.tif ${1}/descr_grey40.tif

$I -size "${CRES}" xc:"rgb(128,128,128)"  ${1}/chunk_grey50.tif
$DL "128,128,128" ${1}/chunk_black.tif ${1}/descl_grey50.tif
$DR "grey50" ${1}/chunk_black.tif ${1}/descr_grey50.tif

$I -size "${CRES}" xc:"rgb(153,153,153)"  ${1}/chunk_grey60.tif
$DL "153,153,153" ${1}/chunk_black.tif ${1}/descl_grey60.tif
$DR "grey60" ${1}/chunk_black.tif ${1}/descr_grey60.tif

$I -size "${CRES}" xc:"rgb(178,178,178)"  ${1}/chunk_grey70.tif
$DL "178,178,178" ${1}/chunk_black.tif ${1}/descl_grey70.tif
$DR "grey70" ${1}/chunk_black.tif ${1}/descr_grey70.tif

$I -size "${CRES}" xc:"rgb(204,204,204)"  ${1}/chunk_grey80.tif
$DL "204,204,204" ${1}/chunk_black.tif ${1}/descl_grey80.tif
$DR "grey80" ${1}/chunk_black.tif ${1}/descr_grey80.tif

$I -size "${CRES}" xc:"rgb(229,229,229)"  ${1}/chunk_grey90.tif
$DL "229,229,229" ${1}/chunk_black.tif ${1}/descl_grey90.tif
$DR "grey90" ${1}/chunk_black.tif ${1}/descr_grey90.tif

# Red saturations
$I -size "${CRES}" xc:"rgb(127,127,127)"  ${1}/chunk_red00.tif
$DL "127,127,127" ${1}/chunk_black.tif ${1}/descl_red00.tif
$DR "red00" ${1}/chunk_black.tif ${1}/descr_red00.tif

$I -size "${CRES}" xc:"rgb(171,112,112)"  ${1}/chunk_red25.tif
$DL "171,112,112" ${1}/chunk_black.tif ${1}/descl_red25.tif
$DR "red25" ${1}/chunk_black.tif ${1}/descr_red25.tif

$I -size "${CRES}" xc:"rgb(204,93,93)"    ${1}/chunk_red50.tif
$DL "204,93,93" ${1}/chunk_black.tif ${1}/descl_red50.tif
$DR "red50" ${1}/chunk_black.tif ${1}/descr_red50.tif

$I -size "${CRES}" xc:"rgb(231,68,68)"    ${1}/chunk_red75.tif
$DL "231,68,68" ${1}/chunk_black.tif ${1}/descl_red75.tif
$DR "red75" ${1}/chunk_black.tif ${1}/descr_red75.tif

# Green saturations
$I -size "${CRES}" xc:"rgb(219,219,219)"  ${1}/chunk_green00.tif
$DL "219,219,219" ${1}/chunk_black.tif ${1}/descl_green00.tif
$DR "green00" ${1}/chunk_black.tif ${1}/descr_green00.tif

$I -size "${CRES}" xc:"rgb(177,234,177)"  ${1}/chunk_green25.tif
$DL "177,234,177" ${1}/chunk_black.tif ${1}/descl_green25.tif
$DR "green25" ${1}/chunk_black.tif ${1}/descr_green25.tif

$I -size "${CRES}" xc:"rgb(137,243,137)"  ${1}/chunk_green50.tif
$DL "137,243,137" ${1}/chunk_black.tif ${1}/descl_green50.tif
$DR "green50" ${1}/chunk_black.tif ${1}/descr_green50.tif

$I -size "${CRES}" xc:"rgb(94,250,94)"    ${1}/chunk_green75.tif
$DL "94,250,94" ${1}/chunk_black.tif ${1}/descl_green75.tif
$DR "green75" ${1}/chunk_black.tif ${1}/descr_green75.tif

# Blue saturations
$I -size "${CRES}" xc:"rgb(78,78,78)"     ${1}/chunk_blue00.tif
$DL "78,78,78" ${1}/chunk_black.tif ${1}/descl_blue00.tif
$DR "blue00" ${1}/chunk_black.tif ${1}/descr_blue00.tif

$I -size "${CRES}" xc:"rgb(76,78,100)"    ${1}/chunk_blue25.tif
$DL "76,78,100" ${1}/chunk_black.tif ${1}/descl_blue25.tif
$DR "blue25" ${1}/chunk_black.tif ${1}/descr_blue25.tif

$I -size "${CRES}" xc:"rgb(72,72,128)"    ${1}/chunk_blue50.tif
$DL "72,72,128" ${1}/chunk_black.tif ${1}/descl_blue50.tif
$DR "blue50" ${1}/chunk_black.tif ${1}/descr_blue50.tif

$I -size "${CRES}" xc:"rgb(64,64,169)"    ${1}/chunk_blue75.tif
$DL "64,64,169" ${1}/chunk_black.tif ${1}/descl_blue75.tif
$DR "blue75" ${1}/chunk_black.tif ${1}/descr_blue75.tif

# Yellow saturations
$I -size "${CRES}" xc:"rgb(247,247,247)"  ${1}/chunk_yellow00.tif
$DL "247,247,247" ${1}/chunk_black.tif ${1}/descl_yellow00.tif
$DR "yellow00" ${1}/chunk_black.tif ${1}/descr_yellow00.tif

$I -size "${CRES}" xc:"rgb(249,249,205)"  ${1}/chunk_yellow25.tif
$DL "249,249,205" ${1}/chunk_black.tif ${1}/descl_yellow25.tif
$DR "yellow25" ${1}/chunk_black.tif ${1}/descr_yellow25.tif

$I -size "${CRES}" xc:"rgb(252,252,162)"  ${1}/chunk_yellow50.tif
$DL "252,252,162" ${1}/chunk_black.tif ${1}/descl_yellow50.tif
$DR "yellow50" ${1}/chunk_black.tif ${1}/descr_yellow50.tif

$I -size "${CRES}" xc:"rgb(254,254,113)"  ${1}/chunk_yellow75.tif
$DL "254,254,113" ${1}/chunk_black.tif ${1}/descl_yellow75.tif
$DR "yellow75" ${1}/chunk_black.tif ${1}/descr_yellow75.tif

# Cyan Saturations
$I -size "${CRES}" xc:"rgb(229,229,229)"  ${1}/chunk_cyan00.tif
$DL "229,229,229" ${1}/chunk_black.tif ${1}/descl_cyan00.tif
$DR "cyan00" ${1}/chunk_black.tif ${1}/descr_cyan00.tif

$I -size "${CRES}" xc:"rgb(201,236,236)"  ${1}/chunk_cyan25.tif
$DL "201,236,236" ${1}/chunk_black.tif ${1}/descl_cyan25.tif
$DR "cyan25" ${1}/chunk_black.tif ${1}/descr_cyan25.tif

$I -size "${CRES}" xc:"rgb(168,242,242)"  ${1}/chunk_cyan50.tif
$DL "168,242,242" ${1}/chunk_black.tif ${1}/descl_cyan50.tif
$DR "cyan50" ${1}/chunk_black.tif ${1}/descr_cyan50.tif

$I -size "${CRES}" xc:"rgb(122,249,249)"  ${1}/chunk_cyan75.tif
$DL "122,249,249" ${1}/chunk_black.tif ${1}/descl_cyan75.tif
$DR "cyan75" ${1}/chunk_black.tif ${1}/descr_cyan75.tif

# Magenta Saturations
$I -size "${CRES}" xc:"rgb(144,144,144)"  ${1}/chunk_magenta00.tif
$DL "144,144,144" ${1}/chunk_black.tif ${1}/descl_magenta00.tif
$DR "magenta00" ${1}/chunk_black.tif ${1}/descr_magenta00.tif

$I -size "${CRES}" xc:"rgb(165,136,165)"  ${1}/chunk_magenta25.tif
$DL "165,136,165" ${1}/chunk_black.tif ${1}/descl_magenta25.tif
$DR "magenta25" ${1}/chunk_black.tif ${1}/descr_magenta25.tif

$I -size "${CRES}" xc:"rgb(189,122,189)"  ${1}/chunk_magenta50.tif
$DL "189,122,189" ${1}/chunk_black.tif ${1}/descl_magenta50.tif
$DR "magenta50" ${1}/chunk_black.tif ${1}/descr_magenta50.tif

$I -size "${CRES}" xc:"rgb(218,98,218)"   ${1}/chunk_magenta75.tif
$DL "218,98,218" ${1}/chunk_black.tif ${1}/descl_magenta75.tif
$DR "magenta75" ${1}/chunk_black.tif ${1}/descr_magenta75.tif

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
    ${1}/chunk_black.tif ${1}/descl_${COLOUR}.tif ${1}/descr_${COLOUR}.tif ${1}/chunk_black.tif \
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

