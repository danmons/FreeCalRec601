# FreeCalRec601
Rec.601/BT.601 calibration DVD and test pattern generator

There exist excellent free calibration discs for Rec.709/HD systems, notably AVS HD 709:
https://www.avsforum.com/forum/139-display-calibration/948496-avs-hd-709-blu-ray-mp4-calibration.html

Sadly nothing similar exists for retro enthusiasts wanting to calibrate their SD displays to era-accurate standards.

These scripts aim to generate accurate test patterns on DVD for use with tools such as HCFR:
* http://hcfr.sf.net
* https://www.avsforum.com/forum/139-display-calibration/1393853-hcfr-open-source-projector-display-calibration-software.html

These scripts come in two flavours currently:
* BT.601-6-525 / bt470bg / PAL
* BT.601-6-625 / smpte170m / NTSC

And output to a .iso file that should burn to a DVD-R (perhaps even a CD-R) and be used in any compatible DVD or similar MPEG2 player.

These us open source image generation tools such as ffmpeg, dvauthor and ImageMagick to generate and assemble all the images and videos required.

A full list of instructions will be available once testing is complete. 
