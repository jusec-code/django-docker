# update_settings.py
import os

project_dir = os.environ.get('DJANGO_PROJECT_DIR')
project_name = os.environ.get('DJANGO_PROJECT_NAME')
settings_path = os.path.join(project_dir, project_name, 'settings.py')

db_name = os.environ.get('POSTGRES_DB')
db_user = os.environ.get('POSTGRES_USER')
db_password = os.environ.get('POSTGRES_PASSWORD')
db_host = os.environ.get('DB_HOST')
db_port = os.environ.get('DB_PORT')

db_settings = f"""
DATABASES = {{
    'default': {{
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '{db_name}',
        'USER': '{db_user}',
        'PASSWORD': '{db_password}',
        'HOST': '{db_host}',
        'PORT': {db_port},
    }}
}}
"""

with open(settings_path, 'r') as file:
    settings = file.readlines()

for i, line in enumerate(settings):
    if line.startswith('DATABASES ='):
        settings[i] = db_settings
        break
else:
    settings.append(db_settings)

with open(settings_path, 'w') as file:
    file.writelines(settings)