# Verwende ein offizielles Python-Laufzeit-Image als Basis
FROM python:3.10-slim

# Setze Umgebungsvariablen
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Erstelle und wechsle in das Arbeitsverzeichnis
WORKDIR /app

# Kopiere die Abhängigkeitsdateien
COPY requirements.txt /app/

# Installiere die Abhängigkeiten
RUN apt-get update && apt-get install -y gcc python3-dev musl-dev netcat-openbsd
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install gunicorn

# Kopiere den Rest des Projekts
COPY . /app/

# Kopiere das Startskript und mache es ausführbar
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Exponiere den Port, auf dem die App läuft
EXPOSE 8000

# Verwende das Startskript als Entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]