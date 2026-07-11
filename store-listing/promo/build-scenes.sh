#!/usr/bin/env bash
# Build the 7 promo scenes (1920x1080) with ImageMagick. Run from this dir.
# Needs: magick, ../png/screenshot-1..5.png, and a QR sample (qr.png) generated from the
# vendored encoder:
#   node --input-type=module -e "import {encodeQr,qrToSvg} from '../../vendor/qr/qr-core.js';\
#   import fs from 'node:fs'; fs.writeFileSync('qr.svg', qrToSvg(encodeQr('https://cleanor.app/tools/qr-code-generator','M'),{size:640,margin:1,dark:'#2f55d4',light:'#ffffff'}))"
#   magick -background none qr.svg -resize 640x640 qr.png
set -euo pipefail
SERIF="/System/Library/Fonts/NewYork.ttf"; SANS="/System/Library/Fonts/HelveticaNeue.ttc"
B1="#5A83FF"; B2="#4576fd"; WHITE="#ffffff"; SUB="#d7e2ff"; PNG="../png"
card(){ local s=$1 q=$2 out=$3; magick -size ${s}x${s} xc:none -fill white -draw "roundrectangle 0,0,$((s-1)),$((s-1)),$((s/8)),$((s/8))" /tmp/cc.png; magick /tmp/cc.png \( qr.png -resize ${q}x${q} \) -gravity center -composite \( +clone -background '#0a1440' -shadow 60x24+0+18 \) +swap -background none -layers merge +repage "$out"; }
magick -size 1920x1080 radial-gradient:"$B1"-"$B2" /tmp/bg.png
card 300 232 /tmp/ci.png
magick -background none -fill "$WHITE" -font "$SERIF" -weight 700 -pointsize 150 label:"Cleanor QR" /tmp/it.png
magick -background none -fill "$SUB" -font "$SANS" -pointsize 46 label:"Scan anything, straight from your browser" /tmp/is.png
magick /tmp/bg.png /tmp/ci.png -gravity north -geometry +0+230 -composite /tmp/it.png -gravity north -geometry +0+600 -composite /tmp/is.png -gravity north -geometry +0+800 -composite -alpha remove scene-intro.png
for n in 1 2 3 4 5; do
  magick "$PNG/screenshot-$n.png" -resize x980 \( +clone -background '#0a1440' -shadow 50x30+0+16 \) +swap -background none -layers merge +repage /tmp/ss.png
  magick -size 1920x1080 radial-gradient:"$B1"-"$B2" /tmp/ss.png -gravity center -composite -alpha remove scene-ss$n.png
done
card 190 148 /tmp/co.png
magick -background none -fill "$WHITE" -font "$SERIF" -weight 700 -pointsize 104 -size 1400x -gravity center caption:"Get it free on the Chrome Web Store" /tmp/ot.png
magick -size 520x110 xc:none -fill white -draw "roundrectangle 0,0,519,109,26,26" \( -background none -fill '#2f55d4' -font "$SANS" -pointsize 44 -gravity center -size 520x110 caption:"＋  Add to Chrome" \) -gravity center -composite /tmp/pill.png
magick -background none -fill "$SUB" -font "$SANS" -pointsize 40 label:"cleanor.app/tools/qr-code-generator" /tmp/ou.png
magick /tmp/bg.png /tmp/co.png -gravity north -geometry +0+150 -composite /tmp/ot.png -gravity north -geometry +0+400 -composite /tmp/pill.png -gravity north -geometry +0+700 -composite /tmp/ou.png -gravity north -geometry +0+860 -composite -alpha remove scene-outro.png
echo "scenes built"
