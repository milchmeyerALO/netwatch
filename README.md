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
