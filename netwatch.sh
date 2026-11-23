#!/bin/bash

set -e

TARGET="10.12.16.100"

# Abstand zwischen zwei Prüfungsstarts in Sekunden
INTERVAL=60

# Führt einen vollständigen Prüfzyklus aus
run_check() {

    # ---------------------------------
    # 1. Ziel und Hostname ermitteln
    # ---------------------------------


    HOSTNAME=$(getent hosts "$TARGET" | awk 'NR == 1 {print $2}')
    
    if [ -z "$HOSTNAME" ]; then
        HOSTNAME="$TARGET"
    fi

    # ---------------------------------
    # 2. Netzwerkverbindung prüfen
    # ---------------------------------

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

    # ---------------------------------
    # 3. Prüfergebnis ausgeben
    # ---------------------------------

    # Ergebnisse ausgeben
    echo "Hostname: $HOSTNAME"
    echo "IP-Adresse: $TARGET"
    echo "Prüfzeitpunkt: $CHECK_DATE"
    echo "Status: $STATUS"
    echo "Antwortzeit: ${RESPONSE_TIME:-N/A} ms"
    
    # Im Function-Test keine Datenbankverbindung aufbauen
    if [ "${NETWATCH_TEST_MODE:-0}" = "1" ]; then
        return 0
    fi
    
    # ---------------------------------
    # 4. Datenbankeintrag speichern
    # ---------------------------------

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
}


# ---------------------------------
# Testmodus: Nur einmal prüfen
# ---------------------------------

if [ "${NETWATCH_TEST_MODE:-0}" = "1" ]; then
    run_check
    exit $?
fi


# ---------------------------------
# Normalbetrieb: Endlosschleife
# ---------------------------------

#Da der Container dauerhaft läuft, sollte NetWatch auf ein Beendigungssignal von Docker reagieren können
trap 'echo "NetWatch wird beendet."; exit 0' SIGTERM SIGINT

while true; do

    # Zeitpunkt des Prüfungsstarts merken
    START=$SECONDS

    # Einen vollständigen Prüfzyklus ausführen
    if ! run_check; then
        echo "WARNUNG: Prüfzyklus mit Fehler beendet."
    fi

    # Laufzeit der Prüfung berechnen
    ELAPSED=$((SECONDS - START))

    # Verbleibende Zeit bis zum nächsten Prüfungsstart
    SLEEP_TIME=$((INTERVAL - ELAPSED))

    if [ "$SLEEP_TIME" -gt 0 ]; then
        sleep "$SLEEP_TIME"
    fi

done
