#!/bin/bash

set -e

TARGET="10.12.16.100"

# Hostname ermitteln
HOSTNAME=$(getent hosts "$TARGET" | awk 'NR == 1 {print $2}')

if [ -z "$HOSTNAME" ]; then
    HOSTNAME="$TARGET"
fi

# Prüfzeitpunkt ermitteln
CHECK_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Standardwerte setzen
STATUS="OFFLINE"
RESPONSE_TIME=""

# Server prüfen
if PING_OUTPUT=$(ping -c 1 -W 2 "$TARGET" 2>&1); then
    STATUS="ONLINE"

    RESPONSE_TIME=$(echo "$PING_OUTPUT" |
        sed -n 's/.*time[=<]\([0-9.]*\) ms.*/\1/p')
fi

# Ergebnisse ausgeben
echo "Hostname: $HOSTNAME"
echo "IP-Adresse: $TARGET"
echo "Prüfzeitpunkt: $CHECK_DATE"
echo "Status: $STATUS"
echo "Antwortzeit: ${RESPONSE_TIME:-N/A} ms"
