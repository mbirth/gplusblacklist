#!/bin/sh
if [ ! -f key.pem ]; then
    ./genkey.sh
fi

SRCDIR="src"
FILENAME="gplusblacklist"

NAME=`grep "\"name\":" src/manifest.json | sed -e 's/^.*: "\(.*\)\".*$/\1/'`
VERSION=`grep "\"version\":" src/manifest.json | sed -e 's/^.*: "\(.*\)\".*$/\1/'`
OUTPUT="$FILENAME-$VERSION.crx"

if [ -f "$SRCDIR.crx" ]; then
    echo "Cleaning up old $SRCDIR.crx."
    rm "$SRCDIR.crx"
fi

echo "Generating $NAME $VERSION..."
google-chrome --pack-extension="$SRCDIR/" --pack-extension-key="key.pem" >/dev/null

if [ ! -f "$SRCDIR.crx" ]; then
    echo "ERROR: Could not compile extension!"
    exit 1
fi

# rename output file
mv "$SRCDIR.crx" "$OUTPUT"

echo "Compiled $OUTPUT ."

# remove Chrome garbage
if [ -f libpeerconnection.log ]; then
    rm libpeerconnection.log
fi
