# FreeCalRec601

[About](#about) | [Download](#download) | [Instructions](#instructions) | [Building](#building)

## About

Rec.601/BT.601 calibration DVD and test pattern generator
* https://en.wikipedia.org/wiki/Rec._601

There exist excellent free calibration discs for Rec.709/HD systems, notably AVS HD 709:
* https://www.avsforum.com/forum/139-display-calibration/948496-avs-hd-709-blu-ray-mp4-calibration.html

Sadly nothing similar exists for retro enthusiasts wanting to calibrate their SD displays to era-accurate standards.

These scripts aim to generate accurate test patterns on DVD for use with tools such as HCFR:
* http://hcfr.sf.net
* https://www.avsforum.com/forum/139-display-calibration/1393853-hcfr-open-source-projector-display-calibration-software.html

These scripts come in two flavours currently:
* BT.601-6-625 / bt470bg / PAL
* BT.601-6-525 / smpte170m / NTSC

And output to an ISO image file that should burn to a DVD-R and be used in any standard DVD or similar MPEG2 player, including a standard unmodded PlayStation 2. 

The ISO file can also be played directly via tools such as VLC or on a modded OG XBox or PlayStation 3 without needing to burn them to a physical disc, useful for testing. 

These us open source image generation tools such as ffmpeg, dvauthor and ImageMagick to generate and assemble all the images and videos required.

## Download

Current binary builds can be downloaded from here:
* [https://stickfreaks.com/freecalrec601](https://stickfreaks.com/freecalrec601)

These are compressed with 7-Zip, so decompress prior to burning/playing.

Match the PAL or NTSC image to whatever it is you want to calibrate.
* NTSC is 480 lines interlaced (480i)
* PAL is 576 lines interlaced (576i)

These differ in a few ways
* Line count / "resolution" (obviously)
* Colour space - these standards have slightly different colour primaries due to changes in line density and other encoding specifics.

In each case, the ffmpeg scripts used to generate the DVD VOB files have specific instructions to convert the RGB primaries to the correct broadcast standard. 

## Instructions

Instructional video here (click to watch on YouTube):

[![Watch the video](https://img.youtube.com/vi/G27RqZtcnj8/hqdefault.jpg)](https://youtu.be/G27RqZtcnj8)


My existing CRT Colour Calibration series on YouTube demonstrates how to use a colorimeter with HCFR.  You can see the vidoes here:
* [Stickfreaks Colour Calibration Videos](https://www.youtube.com/watch?v=3o3awkkAILI&list=PLyXPSTsxUZq5zgE_5ZHi2cdfE2--66DjZ)

These ISO images can be burned to DVD-R media, and used in any standard DVD player or console that supports DVD playback (PlayStation 2, Playstation 3, etc).

Alternatively the ISO image can be played directly by VLC (a Raspberry Pi will work fine) or on a modded OG Xbox, PlayStation 3, etc.

Get a signal out of your playback device to your CRT via whatever method you want to calibrate. Composite video, S-Video, RGB/SCART, YPbPr, whatever. Play the DVD and navigate the menus with your remote.

See the instructional videos linked above on how to use HCFR with a colorimeter, and you can use these DVDs as test pattern generators.

## Building

These are tested and built on an Linux system with free tools installed, specifically Ubuntu 20.04 LTS. Other distros and versions should work fine, assuming you install the following tools:
* imagemagick (builds the source images for the colour patches)
* ffmpeg (transcoding tool to generate the video files in the correct colour spaces)
* sox (generates the blank audio required to keep the DVD format happy)
* genisoimage (supplies mkisofs to build the ISO image)
* dvdauthor (supplies dvdauthor and spumux needed for the DVD menus)

On Ubuntu 20.04, simply run
```
sudo apt install imagemagick ffmpeg sox genisoimage dvdauthor 
```

The tools don't require any special hardware or kernel features, and should run fine in something like Windows 10 and 11 with WSL and Ubuntu from the Microsoft Store.
