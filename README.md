# FreeCalRec601

[About](#about) | [Download](#download) | [Alternatives](#alternatives) | [Instructions](#instructions) | [Building](#building)

## About

FreeCalRec601 is a free [Rec.601/BT.601](https://en.wikipedia.org/wiki/Rec._601) calibration DVD and test pattern generator.  It can be used on any device that 
plays standard NTSC or PAL DVD media, including DVD and Blu-Ray players, video game consoles like the PlayStation 2 and PlayStation 3, etc. 

There exist excellent free calibration discs for Rec.709/HD (High Definition) systems, notably [AVS HD 709](https://www.avsforum.com/threads/avs-hd-709-blu-ray-mp4-calibration.948496/). Sadly nothing similar 
existed for retro enthusiasts wanting to calibrate their SD (Standard Definition) displays to era-accurate standards, which was the motivation for this project.  Its aimed at anyone who wants to ensure their 
older style standard definition display meets specification, from retro gamers to home theatre enthusiasts who may still be using old VHS and DVD playback equipment on CRTs. 

These scripts aim to generate accurate test patterns on DVD for use with tools such as HCFR:
* http://hcfr.sf.net
* https://www.avsforum.com/threads/hcfr-open-source-projector-and-display-calibration-software.1393853/

These scripts come in two flavours currently:
* BT.601-6-625 / bt470bg / PAL
* BT.601-6-525 / smpte170m / NTSC

And output to an ISO image file that should burn to a DVD-R and be used in any standard DVD or similar MPEG2 player, including a standard unmodded PlayStation 2. 

The ISO file can also be played directly via tools such as VLC or on a modded OG XBox or PlayStation 3 without needing to burn them to a physical disc, useful for testing. 

These use open source and 100% free (libre and gratis) image generation tools such as ffmpeg, dvauthor and ImageMagick to generate and assemble all the images and videos required. Everything in this repository can be re-created for free, and used for free without restriction, fees or licensing. 

## Download

Pre-built ISO images, built from this code, ready for playback or burning to DVD-R, can be downloaded from here:
* https://stickfreaks.com/freecalrec601

These are compressed with 7-Zip, so decompress prior to burning/playing.

Match the PAL or NTSC image to whatever it is you want to calibrate.
* NTSC is 480 lines interlaced (aka 480i aka 525-line including blanking), and 29.97Hz frames (59.94Hz fields)
* PAL is 576 lines interlaced (aka 576i aka 625-line including blanking), and 25.00Hz frames (50.00Hz fields)

These differ in two specific ways:
* Line count / resolution / framerate
* Colour space - these standards have slightly different colour primaries due to changes in line density and other encoding specifics, as per the two variations of the Rec.601 standard.

There is no region-locking on the generated DVDs, so you can play PAL on NTSC or vice versa.  But this will produce incorrect colour output.  Ensure you match the DVD to the region of your player and display. 

In each case, the ffmpeg scripts used to generate the DVD VOB files have specific instructions to convert the RGB primaries to the correct broadcast standard. See the notes below as to why these may look different if played back on a desktop PC. 

## Alternatives

Since making this project, some good alternatives have been made available.  I've worked with Artemio and Keith Raney to get these test patterns into certain versions of the [240p Test Suite](https://junkerhq.net/xrgb/index.php?title=240p_test_suite).  At time 
of writing, the Dreamcast and Gamecube versions have these same test patterns on them, and you can use those consoles running the 240p Test Suite as a test pattern generator for CRTs in a similar way to these DVDs. 

## Instructions

Instructional video here (click to watch on YouTube):

[![Watch the video](https://img.youtube.com/vi/G27RqZtcnj8/hqdefault.jpg)](https://youtu.be/G27RqZtcnj8)


My existing CRT Colour Calibration series on YouTube demonstrates how to use a colorimeter with HCFR.  You can watch the entire playlist here (click to watch on YouTube):

[![Watch the video](https://img.youtube.com/vi/695fk63FYFk/hqdefault.jpg)](https://www.youtube.com/watch?v=3o3awkkAILI&list=PLyXPSTsxUZq5zgE_5ZHi2cdfE2--66DjZ)


These ISO images can be burned to DVD-R media, and used in any standard DVD player or console that supports DVD playback (PlayStation 2, Playstation 3, etc).

Alternatively the ISO image can be played directly by VLC (a Raspberry Pi will work fine) or on a modded OG Xbox, PlayStation 3, etc.

Get a signal out of your playback device to your CRT via whatever method you want to calibrate. Composite video, S-Video, RGB/SCART, YPbPr, whatever. Play the DVD and navigate the menus with your remote.

See the instructional videos linked above on how to use HCFR with a colorimeter, and you can use these DVDs as test pattern generators.

Note that playing these DVDs/ISOs or the VOB files within on a desktop PC via a video player like VLC may produce slightly different colours to what you expect.  This is a result of the player not correctly converting the specific Rec.601 primary chromaticities back to what your monitor is configured to (typically sRGB).  Many desktop video players are quite lazy in their colourspace conversions (i.e.: they don't bother at all).  These DVDs are designed specifically for Rec.601 standard output devices, which themselves generally assume the connected display is a standard definition CRT television.  If you want to inspect the colours with a vectorscope (using something like DaVinci Resolve), you'll need to ensure you are setting the correct colourspace for your project (many of these sorts of tools don't ship with Rec.601 colourspace definitions any more either). 

If you want to calibrate sRGB (most PC monitors) or Rec.709 (most HD TVs, or 4K TVs running in SDR mode) displays instead, see the AVS HD 709 links in the "About" section above, or simply use HCFR from a PC or laptop connected directly to your display device. 

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

On Arch Linux, run:
```
sudo pacman -Sy imagemagick ffmpeg sox cdrkit dvdauthor
```

The tools don't require any special hardware or kernel features, and should run fine in something like Windows 10 and 11 with WSL and Ubuntu from the Microsoft Store.
