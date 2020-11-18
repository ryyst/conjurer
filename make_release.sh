#!/bin/sh

OUTPUT="RAKSA_$(date -I)_$(git rev-parse --short HEAD).ZIP"

echo "Zipping HEAD to archive $OUTPUT..."

git archive -o $OUTPUT --prefix=raksa/ --format=zip HEAD
echo "Done!"
