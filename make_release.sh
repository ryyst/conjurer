#!/bin/sh

OUTPUT="LUOJA_$(date -I)_$(git rev-parse --short HEAD).ZIP"

echo "Zipping HEAD to archive $OUTPUT..."

git archive -o $OUTPUT --prefix=luoja/ --format=zip HEAD
echo "Done!"
