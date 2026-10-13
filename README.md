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

Projekt: Netzwerk-Monitoring mit automatisierter Build- und Testpipeline
Repository: https://github.com/milchmeyerALO/netwatch
Betriebssystem: Ubuntu Server 24.04 LTS
Virtualisierung: VirtualBox unter Windows 11
Stand: 12. Oktober 2026

1. Projektbeschreibung

NetWatch ist ein kleines Netzwerk-Monitoring-System zur Überwachung von Servern und anderen Netzwerkgeräten.

Die Anwendung prüft regelmäßig die Erreichbarkeit konfigurierter Systeme und speichert die Ergebnisse zusammen mit dem jeweiligen Status und der Antwortzeit in einer MariaDB-Datenbank. Die Daten sollen anschließend über eine Weboberfläche angezeigt werden können. Für die direkte Verwaltung der Datenbank steht phpMyAdmin zur Verfügung.

Ein weiterer Schwerpunkt des Projekts ist die Automatisierung der Entwicklung und Bereitstellung. Mithilfe von GitHub, Jenkins und Docker wird der Anwendungscode versioniert, automatisiert geprüft und in einem Docker-Image bereitgestellt.

1.1 Projektziele

Netzwerkgeräte und Server regelmäßig auf ihre Erreichbarkeit prüfen.

Prüfergebnisse strukturiert in einer MariaDB-Datenbank speichern.

Die Anwendung in einem Docker-Container ausführen.

Den Quellcode mit Git und GitHub versionieren.

Syntax, Codequalität und Funktion automatisiert mit Jenkins überprüfen.

Fehlerhafte Änderungen erkennen, bevor ein neues Docker-Image als erfolgreich markiert wird.

Eine Weboberfläche zur übersichtlichen Darstellung der Monitoring-Ergebnisse bereitstellen.

2. Aufbau

Das Projekt besteht aus mehreren Komponenten, die unterschiedliche Aufgaben übernehmen.

KomponenteAufgabeNetWatchFührt die Netzwerkprüfungen durch und speichert die ErgebnisseMariaDBSpeichert Systeme, Prüfstatus und PrüfergebnissephpMyAdminErmöglicht die grafische Verwaltung und Einsicht in die DatenbankWeboberflächeDient zur Anzeige der gespeicherten Monitoring-ErgebnisseDockerStellt die Anwendung und die zugehörigen Dienste in Containern bereitDocker ComposeKonfiguriert die Container und deren ZusammenspielJenkinsAutomatisiert die Prüfung und Erstellung des Docker-ImagesGitHubDient zur Versionsverwaltung und als zentrale Quelle des Quellcodes

2.1 Serverumgebung

Die Anwendung kann in einer virtuellen Maschine oder direkt auf dem Gerät betrieben werden. Getestet wurde das System mit Ubuntu Server 24.04 und VirtualBox auf einem Windows-11-Host.

Jenkins wird auf dem Ubuntu-Server betrieben und verwendet die dort verfügbare Docker-Engine für den Image-Build und die Container-Tests.

Der grundlegende Aufbau mit einer VM sieht folgendermaßen aus:

Host-System (Windows 11)
└── VM-Anwendung (VirtualBox)
    └── Linux (Ubuntu Server 24.04)
        ├── Jenkins
        │   └── Pipeline NetWatch
        │       ├── Syntaxprüfung
        │       ├── ShellCheck
        │       ├── Funktionstest
        │       ├── Docker-Build
        │       └── Container-Test
        │
        └── Docker / Docker Compose
            ├── NetWatch
            ├── MariaDB
            ├── phpMyAdmin
            └── Webserver

Die Dienste werden logisch getrennt betrieben. Dadurch kann beispielsweise die Datenbank unabhängig von der Monitoring-Anwendung verwaltet werden.

2.2 Ablauf der Netzwerküberwachung

Die Monitoring-Anwendung prüft die konfigurierten Zielsysteme und ermittelt, ob diese erreichbar sind.

Die Ergebnisse werden in MariaDB gespeichert. Dazu gehören der Zeitpunkt der Prüfung, das geprüfte System, der Status und die Antwortzeit.

Konfigurierte Zielsysteme
          |
          v
      netwatch.sh
          |
          v
   Erreichbarkeitsprüfung
          |
          v
    MariaDB-Verbindung
          |
          v
        MariaDB
          |
          +------------------+
          |                  |
          v                  v
     Weboberfläche      phpMyAdmin
     Ergebnisanzeige    Datenverwaltung

Die Weboberfläche dient der übersichtlichen Darstellung der Daten. phpMyAdmin ist dagegen ein Werkzeug zur direkten Verwaltung der Datenbank und ersetzt kein eigenes Monitoring-Dashboard.

3. Projektdateien

Die zentralen Projektdateien liegen im GitHub-Repository.

DateiBeschreibungREADME.mdBeschreibt das Projekt, seine Komponenten und den grundlegenden AblaufJenkinsfileDefiniert die automatisierte Jenkins-PipelineDockerfileBeschreibt den Aufbau des NetWatch-Docker-Imagescompose.yamlKonfiguriert die Docker-Dienstenetwatch.shHauptskript für die Netzwerküberwachungtest.shEnthält die automatisierten Funktionstests

3.1 netwatch.sh

Das Bash-Skript ist die eigentliche Monitoring-Anwendung. Es führt die Netzwerkprüfungen durch und verarbeitet die Ergebnisse.

Die ermittelten Informationen werden an die Datenbank übergeben. Die Datenbankverbindung wird über Umgebungsvariablen konfiguriert, beispielsweise über DB_HOST, DB_PORT, DB_NAME, DB_USER und DB_PASSWORD.

Die Trennung von Anwendungscode und Konfiguration ermöglicht es, dieselbe Anwendung in unterschiedlichen Umgebungen auszuführen, ohne Zugangsdaten direkt in das Skript schreiben zu müssen.

3.2 test.sh

Das Testskript überprüft, ob die Anwendung die erwartete Funktion erfüllt.

Es wird in zwei unterschiedlichen Umgebungen eingesetzt:

Direkt auf dem Jenkins-Agenten, um die Funktion des Quellcodes zu testen.

Innerhalb des Docker-Containers, um zusätzlich die vorbereitete Laufzeitumgebung zu überprüfen.

Der Container-Test erwartet als letzte Ausgabezeile TEST OK. Wird diese Ausgabe nicht erzeugt oder schlägt der Prozess fehl, wird die entsprechende Pipeline-Stufe als fehlgeschlagen gewertet.

3.3 Dockerfile

Das Dockerfile beschreibt, wie das NetWatch-Image erstellt wird.

Der grundlegende Aufbau lautet:

FROM alpine:3.22

RUN apk add --no-cache bash mariadb-client

WORKDIR /app

COPY netwatch.sh .
COPY test.sh .

RUN chmod +x netwatch.sh test.sh

CMD ["./netwatch.sh"]

Die einzelnen Anweisungen haben folgende Aufgaben:

FROM alpine:3.22: Verwendet Alpine Linux als Basis-Image.

RUN apk add: Installiert Bash und den MariaDB-Client.

WORKDIR /app: Legt das Arbeitsverzeichnis im Container fest.

COPY: Kopiert die benötigten Skripte in das Image.

RUN chmod +x: Setzt die Ausführungsrechte der Skripte.

CMD: Definiert das Programm, das beim Start des Containers ausgeführt wird.

Das Ergebnis ist ein Image mit einer definierten Umgebung für die Monitoring-Anwendung.

3.4 compose.yaml

Docker Compose beschreibt die benötigten Dienste und deren Konfiguration. Dazu gehören die Images, Ports, Umgebungsvariablen, Abhängigkeiten und persistenten Volumes.

Die Konfiguration trennt die Anwendung von der Datenbank und den zusätzlichen Verwaltungs- und Darstellungsdiensten.

Die Dienste kommunizieren innerhalb des Compose-Netzwerks über ihre Dienstnamen. So verwendet NetWatch den Hostnamen db, um die MariaDB zu erreichen.

4. Vorgehen

Das Projekt wird schrittweise entwickelt und anschließend durch eine automatisierte Pipeline überprüft.

4.1 Entwicklung und Versionsverwaltung

Der Quellcode wird mit Git versioniert und in GitHub gespeichert. Änderungen an den Skripten und Konfigurationsdateien können dadurch nachvollzogen werden.

GitHub ist außerdem die Quelle, aus der Jenkins den aktuellen Projektstand abruft.

4.2 Automatisierte Prüfung mit Jenkins

Jenkins lädt den Quellcode aus dem Repository und führt die im Jenkinsfile definierten Prüfungen aus.

Zunächst werden die Bash-Syntax und der Code mit ShellCheck geprüft. Anschließend wird das Testskript ausgeführt.

Erst wenn diese Prüfungen erfolgreich sind, beginnt der Docker-Build.

4.3 Erstellen und Testen des Docker-Images

Jenkins erstellt ein Docker-Image mit einer zur Build-Nummer passenden Kennzeichnung.

Danach startet Jenkins einen Container aus diesem Image und führt darin die Tests erneut aus. So wird überprüft, ob die Anwendung auch in der vorbereiteten Containerumgebung funktioniert.

Nach erfolgreichem Abschluss wird das Image zusätzlich mit dem Tag latest versehen.

4.4 Aufbau der Laufzeitumgebung

Docker Compose stellt die benötigten Container bereit. MariaDB speichert die Monitoring-Daten, phpMyAdmin ermöglicht deren Verwaltung und der Webserver bildet die Grundlage für die Anzeige der Ergebnisse.

Die Compose-Umgebung ist vom Image-Build der Jenkins-Pipeline zu unterscheiden. Die aktuelle Pipeline aktualisiert die gesamte Laufzeitumgebung noch nicht automatisch.

5. CI/CD mit Jenkins

5.1 Grundprinzip

CI/CD steht für Continuous Integration und Continuous Delivery beziehungsweise Continuous Deployment.

Continuous Integration bezeichnet die automatisierte Integration und Überprüfung von Änderungen am Quellcode. Fehler sollen möglichst früh erkannt werden.

Continuous Delivery erweitert diesen Ablauf um die Vorbereitung einer auslieferbaren Version. Continuous Deployment geht darüber hinaus und stellt erfolgreiche Änderungen automatisch in der Zielumgebung bereit.

Im NetWatch-Projekt übernimmt Jenkins die automatisierte Prüfung und Erstellung des Docker-Images.

5.2 Pipeline-Ablauf

GitHub
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

Die Pipeline ist im Jenkinsfile hinterlegt und wird dort als deklarative Pipeline definiert.

5.3 Die Pipeline-Stufen

1. Syntax Check

bash -n netwatch.sh

Bash überprüft die Syntax des Skripts, ohne es regulär auszuführen. Fehlerhafte Anführungszeichen oder unvollständige Kontrollstrukturen können dadurch erkannt werden.

2. ShellCheck

shellcheck netwatch.sh

ShellCheck analysiert den Quellcode statisch und weist auf problematische Konstruktionen sowie typische Fehlerquellen hin.

3. Function Test

./test.sh

Das Testskript wird direkt auf dem Jenkins-Agenten ausgeführt. Es überprüft die erwartete Funktion der Anwendung.

4. Docker Build

docker build -t netwatch-bash:${BUILD_NUMBER} .

Docker erstellt das Image. Die Jenkins-Variable BUILD_NUMBER kennzeichnet, aus welchem Build das Image hervorgegangen ist.

5. Container Test

Jenkins startet einen Container aus dem zuvor erstellten Image und führt darin das Testskript aus.

Anschließend wird die letzte Zeile der Ausgabe geprüft. Nur bei der erwarteten Ausgabe TEST OK wird die Pipeline fortgesetzt.

6. Create Latest Image

docker tag \
  netwatch-bash:${BUILD_NUMBER} \
  netwatch-bash:latest

Das geprüfte Image erhält zusätzlich den Tag latest. Dieser Tag erleichtert die Verwendung des zuletzt erfolgreich erstellten Images.

Er stellt jedoch weder einen Upload in eine Registry noch ein automatisches Deployment dar.

5.4 Fehlerbehandlung

Die Pipeline wird bei einem fehlgeschlagenen Schritt abgebrochen. Dadurch werden nachfolgende reguläre Stufen nicht ausgeführt.

Ein Syntaxfehler verhindert beispielsweise den Beginn des Docker-Builds. Ein fehlgeschlagener Container-Test verhindert, dass das neue Image als latest markiert wird.

Über den post-Block gibt Jenkins abschließend eine Erfolgsmeldung oder eine Fehlermeldung aus.

Dieses Verhalten sorgt dafür, dass ein Image erst nach den definierten Prüfungen den zusätzlichen Tag latest erhält.

6. Docker Compose und Datenbank

NetWatch verwendet Docker Compose, um die einzelnen Komponenten der Anwendung als separate Container zu betreiben. Dadurch können der Netzwerkmonitor, die Datenbank und die Weboberflächen unabhängig voneinander verwaltet werden.

Container und Aufgaben

Container / DienstImageAufgabenetwatchEigenes Image, gebaut über DockerfileFührt das Bash-Skript netwatch.sh aus, prüft das konfigurierte Zielsystem und übermittelt die Prüfergebnisse an die Datenbank.dbmariadbSpeichert die überwachten Systeme, Statuswerte und Prüfergebnisse dauerhaft in der Datenbank netwatchdb.webEigenes Image, gebaut über Dockerfile.webStellt das PHP-Dashboard über einen Apache-Webserver bereit und liest die Prüfergebnisse aus der Datenbank aus.phpmyadminphpmyadminErmöglicht die Verwaltung und Einsicht in die MariaDB-Datenbank über eine grafische Weboberfläche.

Kommunikation zwischen den Containern

Die Container kommunizieren innerhalb des von Docker Compose eingerichteten Netzwerks miteinander. Für Datenbankverbindungen verwenden die Dienste den Compose-Dienstnamen db als Hostnamen und den internen MariaDB-Port 3306.

Der Netzwerkmonitor und das PHP-Dashboard erhalten die Zugangsdaten zur Datenbank über Umgebungsvariablen. Die Zugangsdaten werden von Jenkins für den Deployment-Schritt bereitgestellt und nicht im Git-Repository hinterlegt.

Ports und Zugriff

DienstHost-PortContainer-PortZugriffweb8080http://<Server-IP>/phpmyadmin676780http://<Server-IP>:6767/db–3306Interne Kommunikation im Docker-Netzwerk

Die Datenbank wird nicht über einen veröffentlichten Host-Port bereitgestellt. Die Weboberflächen sind dagegen über die angegebenen Host-Ports erreichbar.

Persistente Daten

Docker Volumes sorgen dafür, dass wichtige Daten auch nach dem Entfernen oder Neuerstellen eines Containers erhalten bleiben.

DatabaseVolume speichert die MariaDB-Daten unter /var/lib/mysql.

WebserverVolume wird unter /var/www/html eingebunden und enthält die Dateien des Webservers.

Die Volumes sind vom Lebenszyklus der Container getrennt. Ein erneutes Erstellen der Container löscht daher nicht automatisch die darin gespeicherten Daten.

Build und Deployment mit Jenkins

Jenkins übernimmt den automatisierten Build- und Deployment-Prozess. Nach dem Abrufen des aktuellen Quellcodes aus Git werden die Tests ausgeführt. Bei erfolgreichem Testlauf baut Jenkins die benötigten Docker-Images und startet beziehungsweise aktualisiert die Dienste mit:

docker compose -p netwatch up -d --build

Die Option --build veranlasst Docker Compose, die Images bei Bedarf neu zu bauen. Mit -d werden die Container im Hintergrund gestartet.

Die Konfiguration restart: always sorgt dafür, dass Docker versucht, die betreffenden Container nach einem Beenden oder einem Neustart des Docker-Dienstes erneut zu starten. Bei einem einmalig ausführbaren Skript wie netwatch.sh muss dabei sichergestellt werden, dass es nicht unmittelbar nach jedem Durchlauf erneut gestartet wird und dadurch zu viele Datenbankeinträge erzeugt.

6.1 MariaDB

MariaDB dient zur dauerhaften Speicherung der Monitoring-Ergebnisse.

Die Zugangsdaten und der Datenbankname werden über Umgebungsvariablen konfiguriert. Die Anwendung verwendet dieselben Verbindungsparameter, um ihre Prüfergebnisse zu speichern.

Die Datenbank wird in einem eigenen Container betrieben und ist dadurch von der Monitoring-Anwendung getrennt.

6.2 phpMyAdmin

phpMyAdmin bietet eine grafische Oberfläche für die Verwaltung der MariaDB.

Der Dienst veröffentlicht den Container-Port 80 unter dem Host-Port 6767. Die Oberfläche ist daher unter folgender Adresse erreichbar:

http://<IP-Adresse-des-Ubuntu-Servers>:6767

Die Portnummer wurde gewählt, damit phpMyAdmin nicht mit Jenkins auf Port 8080 kollidiert.

6.3 Datenbank

Die Datenbank von NetWatch heißt netwatchdb. Die besteht aus den drei Tabellen system, status und checks.

Tabellen

system

Speichert die überwachten Systeme.

AttributBeschreibungsystem_id (PK)Eindeutige ID des Systemssystem_nameName des überwachten Systems

status

Enthält die möglichen Statuswerte einer Prüfung.

AttributBeschreibungstatus_id (PK)Eindeutige ID des Statusstatus_nameStatusbezeichnung, z. B. ONLINE oder OFFLINE

checks

Speichert die Ergebnisse der durchgeführten Systemprüfungen.

AttributBeschreibungcheck_id (PK)Eindeutige ID der Prüfungsystem_id (FK)Verweis auf das geprüfte Systemcheck_dateZeitpunkt der Prüfungstatus_id (FK)Verweis auf den ermittelten Statusresponse_timeAntwortzeit in Millisekunden; darf NULL sein

PK = Primärschlüssel, FK = Fremdschlüssel.

Beziehungen und Kardinalitäten

system zu checks (1): Ein System kann mehrere Prüfergebnisse besitzen. Jedes Prüfergebnis gehört zu genau einem System.

status zu checks (1): Ein Status kann mehreren Prüfergebnissen zugeordnet sein. Jedes Prüfergebnis verweist auf genau einen Status.

Die Tabelle checks verbindet somit das geprüfte System mit dem ermittelten Status und speichert zusätzlich den Prüfzeitpunkt sowie die Antwortzeit.

Datenintegrität

Die Primärschlüssel identifizieren jeden Datensatz eindeutig. Die Fremdschlüssel in checks stellen sicher, dass die referenzierten Systeme und Statuswerte in den zugehörigen Tabellen vorhanden sind.

Die Spalte response_time speichert die Antwortzeit in Millisekunden. Wenn keine Antwortzeit ermittelt werden kann, wird NULL gespeichert.

6.4 Persistente Speicherung

Für die dauerhafte Speicherung der Daten verwendet NetWatch benannte Docker Volumes.

DatabaseVolume speichert die MariaDB-Daten unter /var/lib/mysql.

WebserverVolume wird unter /var/www/html eingebunden und dient der Bereitstellung der Webdateien.

Docker Volumes sind vom beschreibbaren Dateisystem eines Containers getrennt. Dadurch bleiben die gespeicherten Daten grundsätzlich auch nach dem Neuerstellen eines Containers erhalten.

Ein Volume ersetzt jedoch kein Backup. Bei versehentlichem Löschen oder einer Beschädigung der Daten können die gespeicherten Informationen verloren gehen.

6.5 Weboberfläche

Die NetWatch-Weboberfläche basiert auf PHP und Apache. Die Datei web/index.php wird über das Dockerfile.web in das Webserver-Image kopiert. Die PHP-Erweiterung mysqli wird installiert, damit die Webanwendung eine Verbindung zu MariaDB herstellen kann.

Der Dienst web stellt den Container-Port 80 über den Host-Port 80 bereit. Die Oberfläche ist dadurch unter der Adresse des Servers erreichbar.

Die Webanwendung verwendet die Umgebungsvariablen DB_HOST, DB_PORT, DB_NAME, DB_USER und DB_PASSWORD, um die Datenbankverbindung herzustellen. Als Datenbankhost wird der Compose-Dienstname db verwendet.

Das Volume WebserverVolume wird nach /var/www/html eingebunden. Da ein eingebundenes Volume die Dateien im entsprechenden Container-Verzeichnis überlagern kann, müssen Änderungen an der Weboberfläche bei einem erneuten Deployment gesondert berücksichtigt werden.

6.6 Deployment mit Jenkins

Jenkins automatisiert den Build und das Deployment der Docker-Anwendung. Zunächst wird der aktuelle Quellcode aus dem Git-Repository ausgecheckt. Anschließend werden die Shell-Syntax, die Funktionen des Skripts und der Container-Build getestet.

Nur bei erfolgreichem Testlauf wird das Deployment ausgeführt. Dafür verwendet Jenkins folgenden Befehl:

docker compose -p netwatch up -d --build

-p netwatch legt den Compose-Projektnamen fest.

up erstellt und startet die definierten Dienste beziehungsweise aktualisiert sie.

-d startet die Container im Hintergrund.

--build baut die benötigten Images vor dem Start neu.

Die Zugangsdaten für MariaDB werden Jenkins über gespeicherte Credentials bereitgestellt und als Umgebungsvariablen an Docker Compose übergeben. Dadurch müssen die Passwörter nicht im Git-Repository gespeichert werden.

Die Konfiguration restart: always veranlasst Docker, einen Container nach einem Beenden oder einem Neustart des Docker-Dienstes erneut zu starten. Da netwatch.sh derzeit als einzelner Prüflauf ausgeführt wird, muss die Ausführungssteuerung so gestaltet sein, dass der Container nicht unmittelbar nach jedem Prüflauf erneut startet und dadurch unnötig viele Datenbankeinträge erzeugt.

7. Konfiguration und Sicherheit

7.1 Umgebungsvariablen

Die Zugangsdaten werden über Umgebungsvariablen an die Container übergeben.

In der Compose-Datei werden dafür Platzhalter wie ${MARIADB_USER}, ${MARIADB_PASSWORD} und ${MARIADB_ROOT_PASSWORD} verwendet.

Die konkreten Zugangsdaten gehören nicht in das öffentliche GitHub-Repository. Für die lokale Entwicklung kann eine separate .env-Datei verwendet werden, die durch .gitignore vom Commit ausgeschlossen wird. Empfohlen werden jedoch Jenkins-Credentials.

7.2 Jenkins-Zugangsdaten

Hier werden die Zugangsdaten im Jenkins-Credential-Store hinterlegt und werden weder in einer .env-Datei noch direkt in die Jenkinsfile geschrieben oder in der Repository gespeichert. Die Zugangsdaten, die für Datenbanktests benötigt werden, sind so getrennt vom Quellcode verwaltet.

7.3 Netzwerkzugriff

Die veröffentlichten Ports ermöglichen den Zugriff auf die entsprechenden Dienste, sofern die Netzwerkkonfiguration und Firewall dies zulassen.

Insbesondere phpMyAdmin sollte nicht ungeschützt aus öffentlichen Netzen erreichbar sein. Der Zugriff sollte auf die benötigten Benutzer und Netzwerke beschränkt werden.

8. Ausführung und Überprüfung

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

8.3 Jenkins einrichten

Um die Jenkins-Pipeline auszuführen, muss Jenkins erst eingerichtet werden.

Zunächst müssen die Credentials angelegt werden. Hierzu geht man in die Einstellungen, dann zu Credentials und legt zwei Credentials an:

Benutzername und Passwort: Anmeldedaten für die Datenbank

Secret text: Zugangsdaten für die Datenbank als root

Nun kann die Pipeline angelegt werden. Dafür legt man unter "Element anlegen" eine neue Pipeline an. Der empfohlene Name ist "NetWatch". Unter Definition wählt man "Pipeline script from SCM" aus, dort unter SCM "Git" und fügt die Repository-URL (https://github.com/milchmeyerALO/netwatch.git) ein. Anschließend kann man sie mit "Jetzt bauen" ausführen.

8.4 Datenbank einrichten

Ein Template für die Datenbank ist ist in der Repository verfügbar und kann über phpmyadmin importiert werden. Zu prüfende Systeme werden in die Tabelle "systems" eingetragen.

9. Fehleranalyse

ProblemMögliche UrsacheÜberprüfungRepository kann nicht geladen werdenFalsche URL oder fehlende BerechtigungenSCM-Konfiguration und Build-Log prüfenShellCheck schlägt fehlWarnungen oder Fehler im SkriptShellCheck-Ausgabe untersuchenDocker-Build schlägt fehlFehler im Dockerfile oder fehlende DateienBuild-Log kontrollierenContainer-Test schlägt fehlTestfehler oder unerwartete AusgabeAusgabe von test.sh prüfenDatenbankverbindung schlägt fehlFalscher Hostname oder fehlerhafte ZugangsdatenUmgebungsvariablen und Netzwerk prüfenMariaDB startet nichtKonfigurationsfehler oder fehlender SpeicherplatzDatenbank-Logs prüfenWeboberfläche wird nicht angezeigtPHP-Dateien fehlen oder Port ist nicht erreichbarWebserver-Logs und Dateibereitstellung prüfen

Fazit

NetWatch verbindet Netzwerk-Monitoring mit Versionsverwaltung, automatisierter Prüfung und Containerisierung.

Die Bash-Anwendung führt die Netzwerkprüfungen durch und speichert die Ergebnisse in MariaDB. Docker stellt eine definierte Laufzeitumgebung bereit, während Docker Compose die beteiligten Dienste konfiguriert.

Jenkins automatisiert die Überprüfung des Quellcodes und erstellt nach erfolgreichen Tests ein Docker-Image. Dadurch können Fehler frühzeitig erkannt werden, bevor ein neuer Build als erfolgreich gekennzeichnet wird.

Das Projekt bildet damit eine Grundlage für eine vollständige CI/CD-Pipeline, die zukünftig auch das automatisierte Deployment der gesamten Anwendung und ihrer Weboberfläche umfassen kann.
