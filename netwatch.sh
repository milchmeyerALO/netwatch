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


# Status-ID aus der Datenbank ermitteln
case "$STATUS" in
    ONLINE)  STATUS_ID=1 ;;
    OFFLINE) STATUS_ID=2 ;;
esac

# System-ID aus der Datenbank ermitteln
SYSTEM_ID=$(mariadb \
    --host="$DB_HOST" \
    --port="$DB_PORT" \
    --user="$DB_USER" \
    --password="$DB_PASSWORD" \
    "$DB_NAME" \
    --batch --skip-column-names \
    -e "SELECT system_id FROM system WHERE system_name = '$HOSTNAME' LIMIT 1;")

# Antwortzeit für SQL vorbereiten
if [ -n "$RESPONSE_TIME" ]; then
    SQL_RESPONSE_TIME="$RESPONSE_TIME"
else
    SQL_RESPONSE_TIME="NULL"
fi

# Prüfergebnis speichern
mariadb \
    --host="$DB_HOST" \
    --port="$DB_PORT" \
    --user="$DB_USER" \
    --password="$DB_PASSWORD" \
    "$DB_NAME" \
    -e "INSERT INTO checks
        (system_id, check_date, status_id, response_time)
        VALUES
        ($SYSTEM_ID, '$CHECK_DATE', $STATUS_ID, $SQL_RESPONSE_TIME);"

echo "Datenbank: Prüfergebnis gespeichert."
