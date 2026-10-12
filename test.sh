#!/bin/bash

set -e

EXPECTED="Server erreichbar"

ACTUAL=$(./netwatch.sh)

if [ "$ACTUAL" = "$EXPECTED" ]; then
echo "TEST OK"
    exit 0
    else
echo "TEST FEHLGESCHLAGEN"
    echo "Erwartet: $EXPECTED"
    echo "Erhalten: $ACTUAL"
    exit 1
    fi
