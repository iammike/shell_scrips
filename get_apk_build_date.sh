#!/bin/bash

# Pull the build timestamp from Crashlytics-build.properties
# Requires apktool: https://ibotpeaches.github.io/Apktool/install/

[ $# -ne 1 ] && { echo "Usage: $0 <apk_file>"; exit 1; }

dom=$(unzip -p $1 '*/crashlytics-build.properties' | grep ":")
dom=${dom#*#}

echo $dom
