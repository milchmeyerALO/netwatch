# NetWatch

NetWatch ist ein kleines Netzwerk-Monitoring-System zur Überwachung von Servern und anderen Systemen.

Die Anwendung prüft regelmäßig die Erreichbarkeit konfigurierte Systeme und speichert die Ergebnisse zusammen mit Status und Antwortzeit in einer MariaDB-Datenbank.

## Aufbau

- **NetWatch** – führt die Netzwerk-Checks durch
- **MariaDB** – speichert die Prüfergebnisse
- **phpMyAdmin** – Verwaltung und Einsicht in die Datenbank
- **Weboberfläche** – Anzeige der Prüfergebnisse

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
