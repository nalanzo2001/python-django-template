# djangodocker/settings/production.py
from os import environ
from .base import *

# Current mode
MODE = 'Development'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True 
