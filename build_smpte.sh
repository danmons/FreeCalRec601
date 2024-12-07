#!/bin/bash -x

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


## Heights:
# Bottom row is 1/4 or 3/12 of total height
# Small "blue/hue complement" window is 1/12 of total height
# Remaining top row is 8/12 or 1/3 of total height

## Widths
# Colour bars are 1/7 of total width, remainder pixels given to outer bars due to overscan
# 720/7 = 102r6, so we'll make colours on the top row 102 wide, with 3 extra for the outer colours for overscan
#
# bottom row, right most align to colour bars. 102/3=34 for the 3xpluge lines, 105 for the far right
# Remainder is 720-(105+102) = 513 / 4 shapes = 128r1. 
# left-right
# 129 + 128 + 128 + 128 + 34 + 34 + 34 + 105 = 720 pixels

X_COLBAR_INNER=$(( ${XRES}/7 ))
X_COLBAR_REM=$(( (${XRES}%7)/2 ))
X_COLBAR_OUTER=$(( ${X_COLBAR_INNER}+${X_COLBAR_REM} ))

X_PLUGE=$(( ${X_COLBAR_INNER}/3 ))

X_YIQ_TOTAL=$(( ${XRES}-(${X_COLBAR_INNER}+${X_COLBAR_OUTER}) ))
X_YIQ_INNER=$(( ${X_YIQ_TOTAL}/4 ))
X_YIQ_REM=$(( ${X_YIQ_TOTAL}%4 ))
X_YIQ_OUTER=$(( ${X_YIQ_INNER}+${X_YIQ_REM} ))

Y_COLBAR_MAIN=$(( ${YRES}/3 ))
Y_COLBAR_COMP=$(( ${YRES}/12 ))
Y_LOWER=$(( ${YRES}/4 ))

$I -size "${CRES}" xc:"rgb(255,255,255)"  ${1}/chunk_smpte_100_bar_white.tif
$I -size "${CRES}" xc:"rgb(255,255,0)"    ${1}/chunk_smpte_100_bar_yellow.tif
$I -size "${CRES}" xc:"rgb(0,255,255)"    ${1}/chunk_smpte_100_bar_cyan.tif
$I -size "${CRES}" xc:"rgb(0,255,0)"      ${1}/chunk_smpte_100_bar_green.tif
$I -size "${CRES}" xc:"rgb(255,0,255)"    ${1}/chunk_smpte_100_bar_magenta.tif
$I -size "${CRES}" xc:"rgb(255,0,0)"      ${1}/chunk_smpte_100_bar_red.tif
$I -size "${CRES}" xc:"rgb(0,0,255)"      ${1}/chunk_smpte_100_bar_blue.tif

$I -size "${CRES}" xc:"rgb(0,0,255)"      ${1}/chunk_smpte_100_comp_blue.tif
$I -size "${CRES}" xc:"rgb(0,0,0)"        ${1}/chunk_smpte_100_comp_black.tif
$I -size "${CRES}" xc:"rgb(255,0,255)"    ${1}/chunk_smpte_100_comp_magenta.tif
$I -size "${CRES}" xc:"rgb(0,255,255)"    ${1}/chunk_smpte_100_comp_cyan.tif
$I -size "${CRES}" xc:"rgb(255,255,255)"  ${1}/chunk_smpte_100_comp_white.tif

## Taken from Wikipedia
## https://en.wikipedia.org/wiki/SMPTE_color_bars
#
#  Limited range RGB 16-235:
#     R     G    B
# +Q  72    16   118
# +I  106   52   16
# -I  16    70   106
#
#  Full range RGB 0-255: =(${LIMITEDRANGE}-16)*(255/(235-16))
#     R      G      B
# +Q  65.2   0	    118.7
# +I  104.7  41.9   0
# -I  0      62.8   104.7
#
# Bottom row:
# -I, superwhite, +Q, black, pluge (superblack, black, 4% above black), black
#
# DVD/VOB can't do superwhite/superblack, so we'll set these to regular white/black


## 75% EBU
$I -size "${CRES}" xc:"rgb(191,191,191)"  ${1}/chunk_smpte_075_white.tif
$I -size "${CRES}" xc:"rgb(191,191,0)"    ${1}/chunk_smpte_075_yellow.tif
$I -size "${CRES}" xc:"rgb(0,191,191)"    ${1}/chunk_smpte_075_cyan.tif
$I -size "${CRES}" xc:"rgb(0,191,0)"      ${1}/chunk_smpte_075_green.tif
$I -size "${CRES}" xc:"rgb(191,0,191)"    ${1}/chunk_smpte_075_magenta.tif
$I -size "${CRES}" xc:"rgb(191,0,0)"      ${1}/chunk_smpte_075_red.tif
$I -size "${CRES}" xc:"rgb(0,0,191)"      ${1}/chunk_smpte_075_blue.tif
$I -size "${CRES}" xc:"rgb(0,0,0)"        ${1}/chunk_smpte_075_black.tif

## Create final composited images
for INTENSITY in 075 100
do
  $M -size "${RES}" \
    ${1}/chunk_smpte_${INTENSITY}_white.tif    ${1}/chunk_smpte_${INTENSITY}_yellow.tif \
    ${1}/chunk_smpte_${INTENSITY}_cyan.tif     ${1}/chunk_smpte_${INTENSITY}_green.tif  \
    ${1}/chunk_smpte_${INTENSITY}_magenta.tif  ${1}/chunk_smpte_${INTENSITY}_red.tif    \
    ${1}/chunk_smpte_${INTENSITY}_blue.tif     ${1}/chunk_smpte_${INTENSITY}_black.tif  \
    -tile 8x1 -geometry +0+0 ${1}/comp_smpte_${INTENSITY}.tif
done

