from .base import *

DEBUG = False

ALLOWED_HOSTS = [
    'ec2-3-79-16-53.eu-central-1.compute.amazonaws.com',  # Public DNS of your EC2 instance
    '3.79.16.53',  # Public IPv4 address of your EC2 instance
]

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'PlanifyCalendarDB',
        'USER': 'my_db_user',
        'PASSWORD': 'my_db_password',
        'HOST': 'ec2-3-79-16-53.eu-central-1.compute.amazonaws.com',
        'PORT': '5432',
    }
}

# Production security settings
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
