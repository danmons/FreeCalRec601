#!/bin/bash

## Image sequence builder for SD/Rec.601 colour calibration
## Designed for use with ColorHCFR software
## Expects a format passed that matches ffmpeg's "-target"
## i.e.: one of pal-vcd, pal-svcd, pal-dvd, ntsc-vcd, ntsc-svcd, ntsc-dvd

## Assumes "ffmpeg" is in $PATH.

# Set resolutions for disc formats based on video/broadcast/SMPTE standards

case "${1}" in
pal-dvd)
  XRES=720
  YRES=576
  RATE=25
  CSPACE="bt601-6-625"
  CMATRIX="bt470bg"
  CTRC="gamma28"
  VF=pal
  ;;
ntsc-dvd)
  XRES=720
  YRES=480
  RATE="30000/1001"
  CSPACE="bt601-6-525"
  CMATRIX="smpte170m"
  CTRC="smpte170m"
  VF=ntsc
  ;;
*)
  echo "No format supplied"
  exit 1
  ;;
esac


mkdir iso >/dev/null 2>&1

TODAY=$(date +%F)


ls -1d ${1}/comp_*.tif | while read FILE
do
  FILENAME=$(basename "${FILE}")
  FILENAME="${FILENAME%.*}"
  COLOUR=$( echo $FILENAME | awk -F '_' '{print $2}' )

  # Input images are sRGB - same white/chromacity co-ordinates as Rec.709
  # We'll convert the inputs images to the Rec.601 colourspace we want, including PAL or NTSC variances
  ffmpeg -nostdin -y -loop 1 -i "${FILE}" -target "${1}" -r ${RATE} -t 60 -aspect 4:3 \
  -vf "colorspace=${CSPACE}:iall=bt709,tinterlace=interleave_top,fieldorder=tff" \
  -colorspace ${CMATRIX} -color_primaries ${CMATRIX} -color_trc ${CTRC} -flags +ildct+ilme -video_format ${VF} \
  -an -c:v mpeg2video -b:v 8M -minrate:v 5M -maxrate:v 10M -bufsize:v 5M -refs 1 \
  -use_wallclock_as_timestamps 1 \
  "${1}/video_${COLOUR}.vob"

done


## ffmpeg arguments explained
## Many of these are listed in "ffmpeg -h full" output
# -target - sets the intended output target. In this case pal-dvd or ntsc-dvd
# -r - frame rate (field rate will be twice this for interlaced)
# -loop - tell the single frame to loop
# -t - time length for the video loop to run
# -aspect - force viewing aspect ratio to 4:3
# -vf - video filters.  These consist of:
## colorspace=bt601-6-625:iall=bt709 - mathematically converts the colour primaries, white point and gamma from
## bt709 (identical to sRGB) to bt601 for 525 (NTSC) or 625 (PAL) modes.
## tinterlace=interleave_top,fieldorder=tff - force the video to be interlaced, and play the top field first
# -colorspace -color_primaries -color_trc - these appear to only set metadata tags, not do actual colorspace conversion
# -flags +ildct+ilme set interlace flags

#NTSC = SMPTE 170M = BT 601 525
# -colorspace smpte170m -color_primaries smpte170m -color_trc smpte170m

#PAL = BT 470 BG = BT 601 625
#  -colorspace bt470bg -color_primaries bt470bg -color_trc gamma28

## Build sequences for chapters in DVD
cd "${1}"

## Greyscale
echo "file 'video_black.vob'" > sequence_greyscale.txt

ls -1d video_grey*vob | sort | while read FILE
do
  echo "file '${FILE}'" >> sequence_greyscale.txt
done
echo "file 'video_white.vob'" >> sequence_greyscale.txt

## Colours
> sequence_colour.txt
for COLOUR in red green blue yellow cyan magenta white black
do
  echo "file 'video_${COLOUR}.vob" >> sequence_colour.txt
done

## Saturations
> sequence_saturation.txt
for COLOUR in red green blue yellow cyan magenta
do
  ls -1d video_${COLOUR}*.vob | sort | while read FILE
  do
    echo "file '${FILE}'" >> sequence_saturation.txt
  done
done
echo "file 'video_white.vob'" >> sequence_saturation.txt
echo "file 'video_black.vob'" >> sequence_saturation.txt

cd ..

ls -1d ${1}/sequence_*.txt | while read FILE
do
  FILENAME=$(basename "${FILE}")
  FILENAME="${FILENAME%.*}"
  ffmpeg -nostdin -y -f concat -i ${FILE} -target "${1}" \
   -c copy -an  ${1}/${FILENAME}.vob
  #ffmpeg -nostdin -y -f concat -i ${FILE} -i ${1}/${FILENAME}.chapter -map_metadata 1 -use_wallclock_as_timestamps 1 \
  #-target "${1}" -c copy ${1}/${FILENAME}.vob
done

## Make the DVD menu background
## Reguires an audio channel even if silent, so generate 30 seconds of silence
sox -n -r 44000 -c 2 ${1}/silence.wav trim 0.0 30.0

ffmpeg -nostdin -y -loop 1 -i ${1}/menu_comp_large.tif -target "${1}" -r ${RATE} -t 60 -aspect 4:3 \
  -vf "colorspace=bt709:iall=${CSPACE},tinterlace=interleave_top,fieldorder=tff" \
  -colorspace ${CMATRIX} -color_primaries ${CMATRIX} -color_trc ${CTRC} -flags +ildct+ilme -video_format ${VF} \
  -an -c:v mpeg2video -b:v 8M -minrate:v 5M -maxrate:v 10M -bufsize:v 5M -refs 1 \
  -use_wallclock_as_timestamps 1 \
  "${1}/dvd_menu_nosound.vob"


## Combine with the video
ffmpeg -nostdin -y -i ${1}/dvd_menu_nosound.vob -i ${1}/silence.wav -c:v copy -c:a libmp3lame ${1}/dvd_menu.vob
