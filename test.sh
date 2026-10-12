#!/bin/bash

set -e

OUTPUT=$(./netwatch.sh)

echo "$OUTPUT"

echo "$OUTPUT" | grep -q '^Hostname: .\+' 
echo "$OUTPUT" | grep -q '^IP-Adresse: .\+'
echo "$OUTPUT" | grep -q '^Prüfzeitpunkt: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}$'
echo "$OUTPUT" | grep -Eq '^Status: (ONLINE|OFFLINE)$'
echo "$OUTPUT" | grep -Eq '^Antwortzeit: ([0-9]+([.][0-9]+)?|N/A) ms$'

echo "TEST OK"
