#!/bin/bash

echo "-- BUILDING ALL LEVELS"

# The location has a few very specific requirements:
# x-axis:
#   Hidden far left inside the Noita base map's rock. Due to the shaders remembering
#   there is something blocking the sky, regardless that the island is not actually loaded
#   at all.
# y-axis:
#   Be high enough for most biomes' terrain to generate nicely below it.

source files/biomes/spliced/generate_splices.sh prison -18432 -3072

echo "-- All done!"
