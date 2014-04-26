# This script will resize the images as per the android screen densities

# Creates ldpi, mdpi, hdpi, xhdpi and xxhdpi images, using source image as reference

# Automatically copies the resized files to drawable-* folders

# If the drawable-* folders are not available in script's location, they will be created

# Params: source_image ldpi|mdpi|hdpi|xhdpi|xxhdpi [output_filename] [resize width height]

# Examples:

# The "icon.png" file is in xxhdpi size, which needs to be resized to other sizes
# ./this-script.sh icon.png xxhdpi

# The "icon.png" of hdpi size needs to be placed as launcher icon for all screen densities:
# ./this-script.sh icon.png hdpi ic_launcher.png

# The "icon.png" has very large dimensions, so resize it to 96x96 with xxhdpi as reference
# ./this-script.sh icon.png xxhdpi resize 96 96

# The "player-newer.png" has very large dimensions, but required size is 230x80 in xxhdpi screen, 
# as well, required to be resized for all screen dimensions, as "player.png"
# ./this-script.sh player-newer.png xxhdpi player.png resize 230 80

# Author: Nj Subedi
# Date: 27 April 2014
# License: The GASC license at http://njs.com.np/license.html


#!/bin/bash
this=`basename $0`
filename=$1
dpi=$2
outfile=$3

outname=''
w=''
h=''

echo "";

#FOR SOURCE
if [ ${#filename} == 0 ]; then
    echo "No source image defined. Usage: $this sourceimage dpi [output] [resize width height]"
    echo "For eg. if you have an icon.png file in xxhdpi size, use $this icon.png xxhdpi"
    echo "To change icon.png to any other name, say ic_launcher, use $this icon.png xxhdpi ic_launcher.png"
    echo "To resize the original image itself to the xxhdpi size, say 96x96, use: $this icon.png xxhdpi resize 96 96"
    echo "To resize the original image itself to the xxhdpi size, say 96x96, rename it to ic_launcher, use: $this icon.png xxhdpi ic_launcher.png resize 96 96"
    exit;
fi

#FOR DPI
if [ "$dpi" == "ldpi" ] || [ "$dpi" == "mdpi" ] || [ "$dpi" == "hdpi" ] || [ "$dpi" == "xhdpi" ] || [ "$dpi" == "xxhdpi" ] ; then
        echo "";    #do nothing
else
    echo "No source image defined. Usage: $this sourceimage dpi [output] [resize width height]"
    echo "For eg. if you have an icon.png file in xxhdpi size, use $this icon.png xxhdpi"
    echo "To change icon.png to any other name, say ic_launcher, use $this icon.png xxhdpi ic_launcher.png"
    echo "To resize the original image itself to the xxhdpi size, say 96x96, use: $this icon.png xxhdpi resize 96 96"
    echo "To resize the original image itself to the xxhdpi size, say 96x96, rename it to ic_launcher, use: $this icon.png xxhdpi ic_launcher.png resize 96 96"
    exit;
fi

width=`identify $filename | cut -d' ' -f3 | cut -d'x' -f1`
height=`identify $filename | cut -d' ' -f3 | cut -d'x' -f2`
echo "Original dimensions of $filename : $width x $height"
            
#FOR OUTPUT
if [ ${#outfile} == 0 ]; then
    #echo "No output filename and resize information given. Using same as source."
    outname=$(basename "$filename")
    
else
    #FOR RESIZE
    if [ "$outfile" == "resize" ]; then
        outname=$(basename "$filename")
        w=$4
        h=$5
        if [ ${#w} == 0 ] || [ ${#h} == 0 ]; then
            echo "";
            #echo "Resize option found but no output dimensions given. Using source as reference."
        else
            #echo "Output dimensions defined. Resizing source to $w x $h first."
            width=$w
            height=$h
        fi
    else
        outname=$outfile
        #FOR RESIZE
        if [ "$4" == "resize" ]; then
            outname=$(basename "$filename")
            w=$5
            h=$6
            if [ ${#w} == 0 ] || [ ${#h} == 0 ]; then
                echo ""
                #echo "Resize option found but no output dimensions given. Using source as reference."
            else
               # echo "Output dimensions defined. Resizing source to $w x $h first."
                width=$w
                height=$h
            fi
        fi
    fi
fi

echo ""
echo "Is $width x $height the $dpi dimension of $filename and the destination file should be copied as $outname under each drawable-* folder?"

#dpi-l| m | h   | xh| xxh
#0.75 | 1 | 1.5 | 2 | 3 

if [ "$dpi" == "xxhdpi" ]; then
       w_mdpi=$(($width/3));
       h_mdpi=$(($height/3));
fi
if [ "$dpi" == "xhdpi" ]; then
       w_dpi=$(($width/2));
       h_mdpi=$(($height/2));
fi
if [ "$dpi" == "hdpi" ]; then
       w_mdpi=$(($width*2/3));
       h_mdpi=$(($height*2/3));
fi
if [ "$dpi" == "mdpi" ]; then
       w_mdpi=$(($width/1));
       h_mdpi=$(($height/1));
fi
if [ "$dpi" == "ldpi" ]; then
       w_mdpi=$(($width*4/3));
       h_mdpi=$(($height*4/3));
fi

w_ldpi=$(($w_mdpi*3/4));
h_ldpi=$(($h_mdpi*3/4));

w_mdpi=$(($w_mdpi*3/4));
h_mdpi=$(($h_mdpi*3/4));

w_hdpi=$(($w_mdpi*3/2));
h_hdpi=$(($h_mdpi*3/2));

w_xhdpi=$(($w_mdpi*2));
h_xhdpi=$(($h_mdpi*2));

w_xxhdpi=$(($w_mdpi*3));
h_xxhdpi=$(($h_mdpi*3));


echo "";
read -r -p "Are you sure you want to continue? [Y/n] " response
case $response in ([nN][oO]|[n]) 
#    Edited using the answer: http://stackoverflow.com/a/3232082/1765169  
      exit;
esac

echo "Checking/creating directories..."
mkdir -p drawable-ldpi drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi

echo "Resizing for XXHDPI... "
convert -resize "$w_xxhdpi"x"$h_xxhdpi" $filename drawable-xxhdpi/"$outname"
echo "$w_xxhdpi"x"$h_xxhdpi Ok!"

echo "Resizing for XHDPI..."
convert -resize "$w_xhdpi"x"$h_xhdpi" $filename drawable-xhdpi/"$outname"
echo "$w_xhdpi"x"$h_xhdpi Ok!"

echo "Resizing for HDPI..."
convert -resize "$w_hdpi"x"$h_hdpi" $filename drawable-hdpi/"$outname"
echo "$w_hdpi"x"$h_hdpi Ok!"

echo "Resizing for MDPI..."
convert -resize "$w_mdpi"x"$h_mdpi" $filename drawable-mdpi/"$outname"
echo "$w_mdpi"x"$h_mdpi Ok!"

echo "Resizing for LDPI..."
convert -resize "$w_ldpi"x"$h_ldpi" $filename drawable-ldpi/"$outname"
echo "$w_ldpi"x"$h_ldpi Ok!"

echo "Images are being resized. The process may take a few seconds to write the files into respective directory. Please check manually!"
