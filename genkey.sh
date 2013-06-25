#!/bin/sh
# Yes, I'm paranoid!
openssl genrsa 4096 | openssl pkcs8 -topk8 -nocrypt -out key.pem
