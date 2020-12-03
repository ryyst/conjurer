#!/bin/sh

# Aseprite won't save in any other directory than the current one. Ever.
MODNAME="raksa"
SPLICES_PATH="files/biomes/spliced/"
cd $SPLICES_PATH

NAME="$1"
X="$2"
Y="$3"

echo ""
echo "------------------------------------------------"
echo "-- building $NAME"
echo "-- splitting scene images from aseprite project"


# ------------------------------------
# Split the three images from our very specifically structured Aseprite project file
aseprite $NAME.ase -b --filename-format="{title}{tag}.{extension}" --ignore-layer="_guides" --save-as $NAME.png
# ------------------------------------


# ------------------------------------
# Generate the actual splice imagery and xml, with Noita's built-in tooling
echo "-- splicing scene images"
noita_dev -splice_pixel_scene mods/$MODNAME/files/biomes/spliced/$NAME.png -x $X -y $Y
# ------------------------------------


# ------------------------------------
# Noita places the generated splices in its own working directory (not under any mod), and
# also thus generates the default data locations for the XMLs pointing to them. That won't work for us.

# 1. The actual task of copying over of the files is lazily just avoided with a symlink
# 2. Then we just have to replace the wrong pathnames:

# (TODO: also copy over everything, instead of just symlinking shit)

echo "-- replacing pathnames"
sed -i "s|data/biome_impl/|mods/$MODNAME/files/biomes/|g" $NAME.xml
# ------------------------------------


echo "-- building $1 done!"
echo "------------------------------------------------"
echo ""

# Go back! Help out our build_all.sh
cd -
