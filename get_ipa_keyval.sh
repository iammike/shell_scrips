#!/bin/bash

# Pull the value of a key from an IPA's Info.plist

[ $# -ne 2 ] && { echo "Usage: $0 <key> <ipa_file>"; exit 1; }

dom=$(unzip -p "$2" '*/Info.plist' | grep -a -A1 $1 | grep string)
dom=${dom#*>}
dom=${dom%<*}

echo $dom
