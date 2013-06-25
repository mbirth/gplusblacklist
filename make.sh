#!/bin/sh
if [ ! -f key.pem ]; then
    ./genkey.sh
fi

SRCDIR="src"
BUILDDIR="build"
FILENAME="gplusblacklist"

rm $BUILDDIR/*

find "$SRCDIR/" -type f ! -name "*.coffee" -exec cp {} "$BUILDDIR/" \;
coffee -o "$BUILDDIR/" -c "$SRCDIR/"

NAME=`grep "\"name\":" "$BUILDDIR/manifest.json" | sed -e 's/^.*: "\(.*\)\".*$/\1/'`
VERSION=`grep "\"version\":" "$BUILDDIR/manifest.json" | sed -e 's/^.*: "\(.*\)\".*$/\1/'`
OUTPUT="$FILENAME-$VERSION.crx"

if [ -f "$BUILDDIR.crx" ]; then
    echo "Cleaning up old $BUILDDIR.crx."
    rm "$BUILDDIR.crx"
fi

echo "Generating $NAME $VERSION..."
google-chrome --pack-extension="$BUILDDIR/" --pack-extension-key="key.pem" >/dev/null

if [ ! -f "$BUILDDIR.crx" ]; then
    echo "ERROR: Could not compile extension!"
    exit 1
fi

# rename output file
mv "$BUILDDIR.crx" "$OUTPUT"

echo "Compiled $OUTPUT ."

# remove Chrome garbage
if [ -f libpeerconnection.log ]; then
    rm libpeerconnection.log
fi
