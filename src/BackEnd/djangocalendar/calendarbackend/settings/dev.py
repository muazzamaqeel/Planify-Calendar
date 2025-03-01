# calendarbackend/settings/dev.py

from .base import *

DEBUG = True
ALLOWED_HOSTS = ['127.0.0.1', 'localhost']

# Example local Postgres config
DATABASES['default'].update({
    'NAME': 'my_local_db',
    'USER': 'postgres',
    'PASSWORD': 'postgres',
    'HOST': '127.0.0.1',
    'PORT': '5432',
})

# Alternatively, if you want to keep using SQLite for dev:
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': BASE_DIR / 'db.sqlite3',
#     }
# }
