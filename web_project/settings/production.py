# djangodocker/settings/production.py
from os import environ
from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '2gult1d96#@#b2%tz+k9x1q%-4(%f@va-!sbv*q&$t^gpp8-_='

# SECURITY WARNING: don't run with debug turned on in production!
# If you set to False, also add "localhost" to ALLOWED_HOSTS or else
# you'll get "Bad Request" when running locally.
DEBUG = False

# When deploying to Azure App Service, add you <name>.azurewebsites.net 
# domain to ALLOWED_HOSTS; you get an error message if you forget. When you add
# a specific host, you must also add 'localhost' and/or '127.0.0.1' for local
# debugging (which are enabled by default when ALLOWED_HOSTS is empty.)
ALLOWED_HOSTS = [
	'0.0.0.0',
    'localhost',
    '127.0.0.1'
]
 