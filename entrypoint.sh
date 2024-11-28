#!/bin/sh

# Setze die Datenbankeinstellungen
db_engine=${DB_ENGINE}
db_name=${DB_NAME}
db_user=${DB_USER}
db_password=${DB_PASSWORD}
db_host=${DB_HOST}
db_port=${DB_PORT}
django_project=${DJANGO_PROJECT}

project_path="/app/${django_project}"
settings_path="/app/${django_project}/settings.py"

# Überprüfe, ob der Ordner existiert, und erstelle ein neues Django-Projekt, falls nicht
if [ ! -d "$project_path" ]; then
    django-admin startproject $django_project .
fi

# Entferne bestehende Datenbankeinstellungen
sed -i "/^DATABASES = {/,/^}/d" $settings_path

# Füge die neuen Datenbankeinstellungen hinzu
cat <<EOL >> $settings_path

DATABASES = {
    'default': {
        'ENGINE': '$db_engine',
        'NAME': '$db_name',
        'USER': '$db_user',
        'PASSWORD': '$db_password',
        'HOST': '$db_host',
        'PORT': '$db_port',
    }
}
EOL

# Entferne die SQLite3-Datei, wenn sie existiert
sqlite_db_path="/app/db.sqlite3"
if [ -f "$sqlite_db_path" ]; then
    rm "$sqlite_db_path"
fi

# Warte auf die Verfügbarkeit der Datenbank
echo "Warte auf die Verfügbarkeit der Datenbank..."
while ! nc -z $db_host $db_port; do
  sleep 1
done
echo "Datenbank ist verfügbar."

# Führe die Datenbankmigrationen aus
python manage.py migrate

# Erstelle den Superuser, falls er noch nicht existiert
python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='$SUPERUSER_NAME').exists():
    User.objects.create_superuser('$SUPERUSER_NAME', '$SUPERUSER_EMAIL', '$SUPERUSER_PASSWORD')
"

# Starte Gunicorn
exec python manage.py runserver 0.0.0.0:8000