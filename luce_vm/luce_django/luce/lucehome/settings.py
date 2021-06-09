"""
Django settings for lucehome project.

Generated by 'django-admin startproject' using Django 2.0.6.

For more information on this file, see
https://docs.djangoproject.com/en/2.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/2.0/ref/settings/
"""

import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# '/vagrant/luce_django/luce'
# Folder from which manage.py runserver is called

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/2.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ')%8jl5ba3h8jxwab#*x2v1l$c=f05^ac-btpt6*=htjwib()w4'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['*']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'datastore',
    'accounts',
    'search',

    'django_extensions',
]

AUTH_USER_MODEL = 'accounts.User' # changes the built-in user model

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# Re-direct to home view after logout
LOGOUT_REDIRECT_URL = '/'
ROOT_URLCONF = 'lucehome.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR + '/lucehome/templates/'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'lucehome.wsgi.application'


# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

# Use sqlite by default (only one VM required, less resources)
# Can switch to Postgresql via environment variable (see code at the very bottom)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Postgresql Database:
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.postgresql',
#         'NAME': 'lucedb',
#         'USER': 'vagrant',
#         'PASSWORD': 'luce',
#         'HOST': '192.168.72.3',
#         'PORT': '5432',
#     }
# }


# Password validation
# https://docs.djangoproject.com/en/2.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/2.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# ==== SETUP STATIC FILE DIRECTORIES ====

# Simulate a CDN locally:
# This path is outside django project, usually a CDN like AWS S3
LOCAL_STATIC_CDN_PATH = os.path.join(os.path.dirname(BASE_DIR), 'luce_static_files/static_cdn_local')

# Static files (CSS, JavaScript, Images)
STATIC_ROOT = os.path.join(LOCAL_STATIC_CDN_PATH, 'static')
STATIC_URL = '/static/'

# This is where files are uploaded to
MEDIA_ROOT = os.path.join(LOCAL_STATIC_CDN_PATH, 'media')
MEDIA_URL = '/media/'


# These files live inside django project
# Local file changes take place here, then at some point they are uploaded to CDN
STATICFILES_DIRS = [BASE_DIR + '/lucehome/static_files/']

# ==== SWITCH TO PSQL ====

# export DJANGO_USE_PSQL=true

# Override variables in this settings file if DJANGO_USE_PSQL env variable is set
if os.environ.get('DJANGO_USE_PSQL') is not None:
    from lucehome.settings_psql import *

