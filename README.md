# django-docker
Template for Building Django Coding Environment in Docker

Dieses Repository bietet ein Template für den Aufbau einer Django-Entwicklungsumgebung in Docker. Es enthält alle notwendigen Konfigurationsdateien und Skripte, um ein neues Django-Projekt zu erstellen, die Datenbankmigrationen durchzuführen und einen Superuser zu erstellen.

## Voraussetzungen

- Docker
- Docker Compose

## Schritte zum Starten eines neuen Django-Projekts

### 1. Repository klonen

Klonen das Repository auf deinen lokalen Rechner:

```sh
git clone https://github.com/jusec-code/django-docker.git
cd django-docker
```

### 2. .env Datei erstellen
Erstelle eine `.env` Datei im Stammverzeichnis des Projekts und füge die notwendigen Umgebungsvariablen hinzu:
```
DJANGO_PROJECT_NAME=mein_test
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=password
DJANGO_SUPERUSER_EMAIL=admin@example.com
POSTGRES_DB=app_db
POSTGRES_USER=user
POSTGRES_PASSWORD=password
DB_HOST=db
DB_PORT=5432
```

### 3. Start-Script ausführen
Stelle sicher, dass das Start-Skript ausführbar ist und führe es aus:

````
chmod +x [start.sh](http://_vscodecontentref_/1)
[start.sh](http://_vscodecontentref_/2)
````
Das Skript führt die folgenden Schritte aus:

1. Lädt die Umgebungsvariablen aus der `.env` Datei.
2. Erstellt das Django-Projekt mit dem Namen aus der `DJANGO_PROJECT_NAME` Variablen.
3. Aktualisiert die `settings.py` Datei, um die PostgreSQL-Datenbankeinstellungen zu verwenden.
4. Löscht die `db.sqlite3` Datei, falls vorhanden.
5. Baut und startet die Docker-Container.
6. Wartet, bis der Web-Container bereit ist.
7. Führt die Datenbankmigrationen durch.
8. Erstellt den Superuser mit den in der `.env` Datei angegebenen Anmeldeinformationen.
9. Setzt das Passwort für den Superuser.

### 4. Docker-Container starten
Starte den Docker-Container:
````
docker compose up
````
Dein Django-Projekt sollte nun laufen und über `http://localhost:8000` erreichbar sein.

