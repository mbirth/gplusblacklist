#!/bin/sh
# Yes, I'm paranoid!
echo "Generating RSA key in PKCS#8 format..."
openssl genrsa 4096 | openssl pkcs8 -topk8 -nocrypt -out key.pem
