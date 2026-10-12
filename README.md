# NetWatch

NetWatch ist ein kleines Netzwerk-Monitoring-System zur Überwachung von Servern und anderen Systemen.

Die Anwendung prüft regelmäßig die Erreichbarkeit konfigurierte Systeme und speichert die Ergebnisse zusammen mit Status und Antwortzeit in einer MariaDB-Datenbank.

## Aufbau

- **NetWatch** – führt die Netzwerk-Checks durch
- **MariaDB** – speichert die Prüfergebnisse
- **phpMyAdmin** – Verwaltung und Einsicht in die Datenbank
- **Weboberfläche** – Anzeige der Prüfergebnisse

## Dateien
- **Dockerfile**: Legt fest, wie das Docker-Image für NetWatch erstellt wird.
- **Jenkinsfile**: Definiert die CI/CD-Pipeline mit Syntaxprüfung, ShellCheck, Funktionstest, Image-Build und Container-Test.
- **compose.yaml**: Konfiguriert die benötigten Docker-Container und deren Zusammenspiel.
- **netwatch.sh**: Hauptskript von NetWatch zur Prüfung der Erreichbarkeit von Netzwerkgeräten und Servern.
- **test.sh**: Testet die Funktion von netwatch.sh und prüft, ob die erwartete Ausgabe erzeugt wird.

## Vorgehen

Das Projekt wird schrittweise aufgebaut und anschließend über eine CI/CD-Pipeline automatisiert.
1. Entwicklung und Versionsverwaltung über GitHub
2. Automatisierte Prüfung des Bash-Skripts mit Jenkins
3. Erstellen und Testen eines Docker-Images
4. Aufbau der benötigten Container mit Docker Compose
5. Speicherung der Prüfergebnisse in MariaDB
6. Bereitstellung einer Weboberfläche zur Anzeige der Ergebnisse

## CI/CD

Das Projekt wird über Jenkins automatisiert gebaut und getestet.

```text
GitHub
  ↓
Jenkins
  ↓
Tests
  ↓
Docker Image
  ↓
Deployment
```

Der Jenkins-Pipeline-Code befindet sich im `Jenkinsfile`.

Umgebung: Ubuntu Server, Jenkins, Docker, Docker Compose, MariaDB und GitHub
Stand: 12. Oktober 2026

1. Projektübersicht

1.1 Ziel des Projekts

NetWatch ist ein kleines Netzwerk-Monitoring-System zur Überwachung von Servern und anderen Netzwerkgeräten. Die Anwendung prüft regelmäßig, ob konfigurierte Systeme erreichbar sind, und speichert die Ergebnisse in einer MariaDB-Datenbank.

Das Projekt verbindet die Entwicklung einer Bash-Anwendung mit einer automatisierten CI/CD-Pipeline. Ziel ist es, Änderungen am Quellcode systematisch zu überprüfen, als Docker-Image bereitzustellen und die für den Betrieb benötigten Container zu verwalten.

Das Projekt ist im GitHub-Repository verfügbar:

https://github.com/milchmeyerALO/netwatch

1.2 Projektziele

Automatisierte Überprüfung der Bash-Syntax.

Statische Codeanalyse mit ShellCheck.

Automatisierte Funktionstests.

Erstellung und Prüfung eines Docker-Images.

Versionierung des Projekts mit Git und GitHub.

Speicherung der Monitoring-Ergebnisse in MariaDB.

Bereitstellung von Werkzeugen zur Datenbankverwaltung und einer Weboberfläche.

1.3 Verwendete Technologien

TechnologieAufgabeGit und GitHubVersionsverwaltung und Quellcode-RepositoryJenkinsAutomatisierung der Build- und TestschritteBashImplementierung der Monitoring-AnwendungShellCheckStatische Analyse des Shell-SkriptsDockerErstellung und Ausführung von ContainernDocker ComposeKonfiguration und Verwaltung mehrerer ContainerMariaDBSpeicherung der Monitoring-DatenphpMyAdminGrafische Verwaltung der DatenbankPHP und ApacheVorgesehene Bereitstellung der WeboberflächeUbuntu ServerServerbetriebssystem für die Projektumgebung

2. Systemarchitektur

2.1 Aufbau der Entwicklungs- und Laufzeitumgebung

Der Server wird als virtuelle Maschine unter VirtualBox betrieben. Auf dem Gastsystem Ubuntu Server 24.04 befinden sich Jenkins und Docker.

Jenkins läuft direkt auf dem Ubuntu-Host. Dadurch kann die Pipeline die dort installierte Docker-Engine verwenden, ohne eine zusätzliche Docker-in-Docker-Umgebung einrichten zu müssen.

Der Aufbau lässt sich folgendermaßen darstellen:

Windows 11
└── VirtualBox
    └── Ubuntu Server 24.04 (Minzerver)
        ├── Jenkins
        │   └── Pipeline: NetWatch
        │       ├── Syntaxprüfung
        │       ├── ShellCheck
        │       ├── Funktionstest
        │       ├── Docker-Build
        │       ├── Container-Test
        │       └── Image-Tagging
        │
        └── Docker
            ├── NetWatch
            ├── MariaDB
            ├── phpMyAdmin
            └── Apache/PHP-Webserver

GitHub dient als zentrale Quelle für den versionierten Projektcode. Jenkins lädt den Code aus dem Repository und verarbeitet ihn anhand der im Jenkinsfile definierten Pipeline.

2.2 Monitoring-Datenfluss

Die Anwendung und die Datenbank arbeiten zusammen, um Prüfergebnisse dauerhaft zu speichern.

Konfigurierte Zielsysteme
          |
          v
     netwatch.sh
          |
          v
   Erreichbarkeitsprüfung
          |
          v
     MariaDB-Client
          |
          v
       MariaDB
          |
          v
   Datenbankabfrage
          |
          v
  Weboberfläche / phpMyAdmin

Die Datenbankverbindung wird über Umgebungsvariablen konfiguriert. Innerhalb des Docker-Compose-Netzwerks wird der Dienstname db als Hostname verwendet. localhost wäre aus Sicht des NetWatch-Containers der Container selbst und nicht der Datenbankserver.

3. Repository und Dateien

Das GitHub-Repository enthält die zentralen Dateien für Entwicklung, Tests und Containerbetrieb.

DateiFunktionJenkinsfileDefiniert die automatisierte CI/CD-PipelineDockerfileBeschreibt den Aufbau des NetWatch-Imagescompose.yamlKonfiguriert die Laufzeitdienste und ihre Verbindungennetwatch.shEnthält die Monitoring-Logiktest.shFührt automatisierte Funktionstests ausREADME.mdEnthält die grundlegende Projektbeschreibung

3.1 netwatch.sh

Das Bash-Skript bildet die eigentliche Monitoring-Anwendung.

Es prüft konfigurierte Systeme auf Erreichbarkeit und speichert die ermittelten Ergebnisse in MariaDB. Die gespeicherten Informationen umfassen unter anderem:

Identifikation des überwachten Systems

Hostname und IP-Adresse

Zeitpunkt der Prüfung

Ergebnis beziehungsweise Status der Prüfung

Antwortzeit

Die Anwendung verwendet den MariaDB-Client, um SQL-Anweisungen an die Datenbank zu senden. Die Verbindungsparameter werden über Umgebungsvariablen bereitgestellt.

3.2 test.sh

Das Testskript überprüft die Funktion der Bash-Anwendung. Es ermöglicht, grundlegende Erwartungen automatisiert zu kontrollieren, anstatt sich ausschließlich auf eine manuelle Ausführung zu verlassen.

Das Skript wird sowohl direkt in Jenkins als auch innerhalb des erstellten Docker-Images ausgeführt.

Der Container-Test erwartet als letzte Ausgabezeile den Text TEST OK. Wird dieser Wert nicht gefunden oder schlägt der Testprozess fehl, wird die entsprechende Pipeline-Stufe als fehlgeschlagen behandelt.

3.3 Dockerfile

Das Dockerfile definiert die Umgebung, in der NetWatch ausgeführt wird.

Der aktuelle Aufbau verwendet Alpine Linux als Basis:

FROM alpine:3.22

RUN apk add --no-cache bash mariadb-client

WORKDIR /app

COPY netwatch.sh .
COPY test.sh .

RUN chmod +x netwatch.sh test.sh

CMD ["./netwatch.sh"]

Die wichtigsten Anweisungen:

FROM: Legt das Basis-Image fest.

RUN: Installiert Bash und den MariaDB-Client.

WORKDIR: Legt das Arbeitsverzeichnis im Container fest.

COPY: Überträgt die Skripte in das Image.

chmod +x: Macht die Skripte ausführbar.

CMD: Definiert den Standardprozess beim Start des Containers.

Das Image enthält damit die benötigten Programme und Skripte. Die eigentliche Laufzeitkonfiguration, beispielsweise die Datenbankverbindung, wird beim Start über Umgebungsvariablen ergänzt.

4. CI/CD mit Jenkins

4.1 Grundprinzip

CI/CD steht für Continuous Integration und Continuous Delivery beziehungsweise Deployment.

Continuous Integration bedeutet, dass Änderungen am Quellcode regelmäßig zusammengeführt und automatisiert überprüft werden. Durch automatisierte Tests können Fehler früh erkannt werden.

Im NetWatch-Projekt übernimmt Jenkins diese Prüfungen und erstellt anschließend ein Docker-Image, sofern die vorherigen Pipeline-Stufen erfolgreich waren.

Der Ablauf ist:

GitHub-Repository
        |
        v
  Jenkins Checkout
        |
        v
    Syntax Check
        |
        v
     ShellCheck
        |
        v
   Function Test
        |
        v
    Docker Build
        |
        v
   Container Test
        |
        v
 Create Latest Image

Wichtig: Die derzeitige Jenkins-Pipeline erstellt und testet Docker-Images. Sie führt nicht automatisch docker compose up -d aus und aktualisiert damit noch nicht automatisch die komplette Laufzeitumgebung aus compose.yaml.

4.2 Jenkinsfile

Das Jenkinsfile beschreibt die Pipeline deklarativ in Groovy. Es befindet sich direkt im GitHub-Repository, sodass der Build-Ablauf gemeinsam mit dem Anwendungscode versioniert wird.

Der Pipeline-Block agent any erlaubt Jenkins, einen verfügbaren Agenten für die Ausführung zu verwenden. In der aktuellen Umgebung muss dieser Agent Zugriff auf Bash, ShellCheck und Docker haben.

Die Pipeline besteht aus sechs Stufen.

Stufe 1: Syntax Check

stage('Syntax Check') {
    steps {
        sh 'bash -n netwatch.sh'
    }
}

bash -n prüft die Syntax des Skripts, ohne es tatsächlich auszuführen.

Dadurch lassen sich beispielsweise fehlerhafte Anführungszeichen, unvollständige Kontrollstrukturen oder andere Syntaxfehler erkennen.

Stufe 2: ShellCheck

stage('ShellCheck') {
    steps {
        sh 'shellcheck netwatch.sh'
    }
}

ShellCheck analysiert das Skript statisch. Dabei werden mögliche Fehlerquellen, problematische Konstruktionen und typische Fehler bei der Bash-Programmierung erkannt.

Im Gegensatz zu einem Funktionstest wird das Programm dafür nicht regulär ausgeführt.

ShellCheck muss auf dem Jenkins-Agenten installiert sein.

Stufe 3: Function Test

stage('Function Test') {
    steps {
        sh './test.sh'
    }
}

In dieser Stufe wird das Testskript direkt auf dem Jenkins-Agenten ausgeführt.

Damit wird geprüft, ob die erwartete Funktion der Anwendung gegeben ist. Schlägt der Test fehl und liefert einen Fehlerstatus zurück, bricht Jenkins die Pipeline vor dem Image-Build ab.

Stufe 4: Docker Build

stage('Docker Build') {
    steps {
        sh 'docker build -t netwatch-bash:${BUILD_NUMBER} .'
    }
}

Docker erstellt ein Image auf Basis des Dockerfiles.

Die Variable ${BUILD_NUMBER} wird von Jenkins bereitgestellt und enthält die laufende Build-Nummer. Dadurch erhält jeder Build einen eigenen Image-Tag.

Beispielsweise könnte ein Image so heißen:

netwatch-bash:15

Die Versionsnummer ermöglicht es, verschiedene Build-Ergebnisse voneinander zu unterscheiden.

Stufe 5: Container Test

stage('Container Test') {
    steps {
        sh '''
            OUTPUT=$(docker run --rm netwatch-bash:${BUILD_NUMBER} ./test.sh)
            LAST_LINE=$(echo "$OUTPUT" | tail -n 1)

            if [ "$LAST_LINE" = "TEST OK" ]; then
                echo "Docker-Test erfolgreich!"
            else
                echo "Docker-Test fehlgeschlagen!"
                exit 1
            fi
        '''
    }
}

In dieser Stufe wird das zuvor erstellte Image gestartet und test.sh innerhalb des Containers ausgeführt.

Die Option --rm entfernt den Testcontainer nach dem Ende seiner Ausführung.

Jenkins prüft die letzte Zeile der Ausgabe. Nur wenn diese exakt TEST OK lautet, wird der Test als erfolgreich gewertet.

Dieser Schritt ist wichtig, weil ein Skript außerhalb eines Containers funktionieren kann, im Image jedoch beispielsweise Programme oder Dateien fehlen könnten.

Der Container-Test prüft somit zusätzlich die vorbereitete Laufzeitumgebung.

Stufe 6: Create Latest Image

stage('Create Latest Image') {
    steps {
        sh '''
            docker tag \
                netwatch-bash:${BUILD_NUMBER} \
                netwatch-bash:latest
        '''
    }
}

Wenn alle vorherigen Stufen erfolgreich waren, erhält das geprüfte Image zusätzlich den Tag latest.

Damit kann es über einen festen Namen angesprochen werden, ohne dass bei jeder Verwendung die konkrete Build-Nummer bekannt sein muss.

Der Tag latest wird hierbei lediglich lokal vergeben. Er bedeutet nicht automatisch, dass ein Image in eine Registry hochgeladen oder auf einem Produktivsystem bereitgestellt wurde.

4.3 Verhalten bei Fehlern

Jenkins führt die Pipeline-Stufen nacheinander aus. Schlägt ein Schritt fehl, werden die nachfolgenden regulären Stufen nicht weiter ausgeführt.

Beispiele:

Ein Syntaxfehler verhindert den Übergang zu den nachfolgenden Prüfungen.

Ein fehlgeschlagener Funktionstest verhindert den Image-Build.

Ein fehlgeschlagener Container-Test verhindert das Tagging als latest.

Am Ende gibt der post-Block eine Erfolgsmeldung oder eine Fehlermeldung aus.

Dadurch ist im Jenkins-Build nachvollziehbar, ob der aktuelle Stand die definierten Prüfungen bestanden hat.

5. Docker Compose und die Laufzeitdienste

5.1 Aufgabe von Docker Compose

Docker Compose verwaltet mehrere zusammengehörige Container anhand einer YAML-Konfigurationsdatei.

Im Projekt übernimmt compose.yaml die Konfiguration der Dienste:

DienstAufgabenetwatchFührt die Monitoring-Anwendung ausdbStellt die MariaDB-Datenbank bereitphpmyadminErmöglicht die grafische DatenbankverwaltungwebStellt die Apache/PHP-Webserverumgebung bereit

Die Dienste können über das von Docker Compose bereitgestellte Netzwerk miteinander kommunizieren.

5.2 NetWatch-Dienst

Der Dienst netwatch wird aus dem lokalen Dockerfile erstellt:

netwatch:
  build: .
  restart: always
  environment:
    DB_HOST: db
    DB_PORT: 3306
    DB_NAME: netwatchdb
    DB_USER: ${MARIADB_USER}
    DB_PASSWORD: ${MARIADB_PASSWORD}

build: . weist Docker Compose an, das Image aus dem aktuellen Projektverzeichnis zu erstellen.

Die Datenbankverbindung wird über Umgebungsvariablen konfiguriert. Der Hostname db verweist auf den Datenbankdienst im Compose-Netzwerk.

restart: always weist Docker an, den Container grundsätzlich erneut zu starten, wenn er beendet wurde. Diese Einstellung ersetzt allerdings keine Fehlerüberwachung der Anwendung.

5.3 MariaDB-Dienst

Der Dienst db verwendet ein MariaDB-Image:

db:
  image: mariadb
  restart: always
  environment:
    MARIADB_DATABASE: netwatchdb
    MARIADB_USER: ${MARIADB_USER}
    MARIADB_PASSWORD: ${MARIADB_PASSWORD}
    MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
  volumes:
    - DatabaseVolume:/var/lib/mysql

Die Umgebungsvariablen definieren die Datenbank und die Zugangsdaten bei der Initialisierung.

Das Volume DatabaseVolume wird nach /var/lib/mysql eingebunden. Dadurch bleiben die Datenbankdateien außerhalb des beschreibbaren Container-Dateisystems erhalten.

Wird der Container ersetzt, bleiben die Daten grundsätzlich im benannten Volume erhalten. Ein Volume ist jedoch kein vollständiges Backup und schützt nicht vor jedem Datenverlust.

5.4 phpMyAdmin

phpMyAdmin bietet eine grafische Oberfläche für die Verwaltung von MariaDB.

Die aktuelle Konfiguration veröffentlicht den Container-Port 80 unter Port 6767 des Ubuntu-Hosts:

phpmyadmin:
  image: phpmyadmin
  restart: always
  ports:
    - 6767:80
  environment:
    - PMA_ARBITRARY=1
  depends_on:
    - db

Die Oberfläche ist damit unter folgender Adresse erreichbar, sofern Netzwerk und Firewall den Zugriff zulassen:

http://<IP des Servers>:6767

Port 6767 wurde gewählt, damit phpMyAdmin nicht mit dem auf Port 8080 betriebenen Jenkins kollidiert.

depends_on legt eine Startreihenfolge fest, garantiert für sich allein aber nicht, dass MariaDB bereits vollständig betriebsbereit ist.

5.5 Webserver

Der Dienst web verwendet php:apache und veröffentlicht Port 80:

web:
  image: php:apache
  restart: always
  ports:
    - 80:80
  depends_on:
    - db

Damit wird ein Apache-Webserver mit PHP-Unterstützung gestartet.

Aktueller Stand: Die Compose-Konfiguration stellt den Webserver-Container bereit. Eine vollständige Integration der projektspezifischen Weboberfläche muss zusätzlich sicherstellen, dass der PHP-Code in das Image kopiert oder korrekt eingebunden wird. Allein durch image: php:apache wird die eigene NetWatch-Weboberfläche noch nicht ausgeliefert.

6. Datenbank und Datenmodell

MariaDB speichert die Ergebnisse der Netzwerkprüfungen dauerhaft.

Das Datenmodell verwendet drei zentrale Tabellen:

TabelleZwecksystemEnthält die überwachten SystemestatusEnthält die möglichen Prüfstatuscheck beziehungsweise der implementierte PrüfdatensatzSpeichert einzelne Prüfergebnisse

Die genaue Benennung der Prüftabelle ist anhand des tatsächlich installierten Datenbankschemas zu überprüfen. In der bisherigen Implementierung wurde die Tabelle zunächst mit einem Tippfehler angelegt und anschließend auf check_id als Primärschlüssel korrigiert.

Die Prüfergebnisse enthalten unter anderem den Prüfzeitpunkt, den Status und die Antwortzeit. Fremdschlüssel verknüpfen die Prüfergebnisse mit dem überwachten System und dem jeweiligen Status.

Das Datenmodell vermeidet dadurch, dass Hostinformationen und Statusbeschreibungen bei jeder einzelnen Prüfung vollständig wiederholt werden müssen.

7. Konfiguration und Zugangsdaten

7.1 Umgebungsvariablen

Die Zugangsdaten werden in compose.yaml über Variablen wie ${MARIADB_USER}, ${MARIADB_PASSWORD} und ${MARIADB_ROOT_PASSWORD} referenziert.

Die konkreten Werte sollten nicht direkt in das öffentliche GitHub-Repository geschrieben werden.

Für die lokale Compose-Konfiguration kann eine separate .env-Datei verwendet werden. Diese Datei muss durch .gitignore vom Commit ausgeschlossen sein.

Beispiel für die Struktur einer lokalen Konfiguration:

MARIADB_USER=<datenbank-benutzer>
MARIADB_PASSWORD=<datenbank-passwort>
MARIADB_ROOT_PASSWORD=<root-passwort>

Die Platzhalter sind durch geeignete Werte zu ersetzen. Die Datei enthält echte Zugangsdaten und darf nicht veröffentlicht werden.

7.2 Passwörter und Zugangsdaten

Die Zugangsdaten der Datenbank gehören nicht in das Jenkinsfile.

Diese werden über den Jenkins-Credential-Store eingetragen.

8. Installation und Ausführung

8.1 Voraussetzungen

NetWatch setzt eine Linux-Distribution voraus. Diese kann in einer VM oder direkt betrieben werden. Getestet wurde das System in einer VM mit folgender Konfiguration:

System: Ubuntu Server 24.04

CPU mit 4 Kernen

Arbeitsspeicher: 4 GB

GPU: 128 MB

Netzwerk-Adapter: Netzwerkbrücke + NAT

Des weiteren werden folgende Programme benötigt:

Git

Jenkins

Docker Engine

Docker Compose

Bash

ShellCheck

Java (OpenJDK)

Der Jenkins-Ausführungsagent benötigt Zugriff auf die benötigten Programme sowie auf die Docker-Engine sowie Java.

8.3 Jenkins einrichten

Um die Jenkins-Pipeline auszuführen, muss Jenkins erst eingerichtet werden.

Zunächst müssen die Credentials angelegt werden. Hierzu geht man in die Einstellungen, dann zu Credentials und legt zwei Credentials an:

Benutzername und Passwort: Anmeldedaten für die Datenbank

Secret text: Zugangsdaten für die Datenbank als root

Nun kann die Pipeline angelegt werden. Dafür legt man unter "Element anlegen" eine neue Pipeline an. Der empfohlene Name ist "NetWatch". Unter Definition wählt man "Pipeline script from SCM" aus, dort unter SCM "Git" und fügt die Repository URL (https://github.com/milchmeyerALO/netwatch.git) ein. Anschließend kann man sie mit "Jetzt bauen" ausführen.

8.4 Datenbank einrichten

Ein Template für die Datenbank ist im Repository enthalten. Dieses kann über phpmyadmin importiert werden.

9. Fehleranalyse

ProblemMögliche UrsachePrüfschrittJenkins kann das Repository nicht ladenFalsche Repository-URL oder fehlende BerechtigungenSCM-Konfiguration und Build-Log prüfenShellCheck schlägt fehlInstalliertes Werkzeug fehlt oder Code enthält WarnungenShellCheck-Ausgabe untersuchenDocker-Build schlägt fehlFehler im Dockerfile oder fehlende DateienBuild-Log und Projektverzeichnis prüfenContainer-Test schlägt fehlFalsche Ausgabe oder Fehler im TestprozessAusgabe von test.sh untersuchenNetWatch erreicht MariaDB nichtFalscher Hostname oder fehlerhafte ZugangsdatenUmgebungsvariablen und Compose-Netzwerk prüfenMariaDB startet nichtUngültige Konfiguration oder unzureichender Speicherplatzdocker compose logs db ausführenDaten fehlen nach Container-NeuerstellungVolume fehlt, wurde geändert oder Daten wurden gelöschtVolume-Konfiguration prüfenWeboberfläche ist nicht erreichbarWebdateien fehlen oder Port ist nicht erreichbarContainer-Logs, Portfreigabe und Dateibereitstellung prüfen

Ein besonders wichtiger Unterschied besteht zwischen einem erfolgreichen Image-Build und einer erfolgreich laufenden Gesamtanwendung: Die Jenkins-Pipeline testet das NetWatch-Image, aber nicht automatisch sämtliche Verbindungen zwischen NetWatch, MariaDB, phpMyAdmin und dem Webserver.

Fazit

Das NetWatch-Projekt verbindet Netzwerk-Monitoring mit automatisierter Softwareprüfung und Containerisierung.

Jenkins übernimmt die wiederholbaren Prüf- und Build-Schritte. Docker stellt eine definierte Laufzeitumgebung für die Bash-Anwendung bereit, während Docker Compose die zugehörigen Dienste konfiguriert. MariaDB ermöglicht die dauerhafte Speicherung der Prüfergebnisse.

Der wesentliche Vorteil besteht darin, dass Änderungen am Anwendungscode systematisch geprüft werden können, bevor ein neues Docker-Image als erfolgreicher Build markiert wird. Gleichzeitig bildet das Projekt eine Grundlage für die spätere Erweiterung um ein vollständig automatisiertes Deployment und eine integrierte Weboberfläche.
