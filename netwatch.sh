#!/bin/bash

set -e

TARGET="10.12.16.100"
MESSAGE=""

if ping -c 1 -W 2 "$TARGET" > /dev/null 2>&1; then
    MESSAGE="Server erreichbar"
fi

if [ "$MESSAGE" = "" ]; then
    MESSAGE="Server nicht erreichbar"
fi

echo "$MESSAGE"
