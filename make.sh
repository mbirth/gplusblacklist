#!/bin/sh
google-chrome --pack-extension=src --pack-extension-key=key.pem

# rename output file
mv src.crx gplusblacklist.crx

# remove Chrome garbage
if [ -f libpeerconnection.log ]; then
    rm libpeerconnection.log
fi
