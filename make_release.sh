#!/bin/sh

OUTPUT="raksa_$(date -I)_$(git rev-parse --short HEAD).zip"

echo "Zipping HEAD to archive $OUTPUT..."

git archive -o $OUTPUT --prefix=raksa/ --format=zip HEAD
echo "Done!"
