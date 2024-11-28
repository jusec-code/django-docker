#!/bin/bash

# Laden der Umgebungsvariablen aus der .env Datei
export $(grep -v '^#' .env | xargs)

# Erstellen des Django-Projekts
docker compose run web django-admin startproject $DJANGO_PROJECT_NAME .

# Aktualisieren der settings.py Datei
SETTINGS_PATH="./app/$DJANGO_PROJECT_NAME/settings.py"

if [ ! -f "$SETTINGS_PATH" ]; then
    echo "settings.py Datei nicht gefunden!"
    exit 1
fi

DB_SETTINGS=$(cat <<EOF
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '$POSTGRES_DB',
        'USER': '$POSTGRES_USER',
        'PASSWORD': '$POSTGRES_PASSWORD',
        'HOST': '$DB_HOST',
        'PORT': '$DB_PORT',
    }
}
EOF
)

# Entfernen des alten DATABASES Eintrags und Hinzufügen des neuen Eintrags
sed -i "/^DATABASES = {/,/^}/d" $SETTINGS_PATH
echo "$DB_SETTINGS" >> $SETTINGS_PATH

# Löschen der db.sqlite3 Datei, falls vorhanden
SQLITE_DB_PATH="./app/db.sqlite3"
if [ -f "$SQLITE_DB_PATH" ]; then
    rm "$SQLITE_DB_PATH"
    echo "db.sqlite3 Datei gelöscht."
fi

# Erstellen und Starten der Docker-Container
docker compose up --build -d

# Warten, bis der Web-Container bereit ist
echo "Warten auf den Web-Container..."
sleep 10

# Datenbankmigrationen durchführen
docker compose exec web python /app/manage.py makemigrations
docker compose exec web python /app/manage.py migrate

# Erstellen des Superusers
docker compose exec web python /app/manage.py createsuperuser --noinput --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL

# Setzen des Passworts für den Superuser
docker compose exec web python /app/manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); user = User.objects.get(username='$DJANGO_SUPERUSER_USERNAME'); user.set_password('$DJANGO_SUPERUSER_PASSWORD'); user.save()"

echo "Initialisierung abgeschlossen."