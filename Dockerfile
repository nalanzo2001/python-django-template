# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

# Set the port on which the app runs; make both values the same.
#
# IMPORTANT: When deploying to Azure App Service, go to the App Service on the Azure 
# portal, navigate to the Applications Settings blade, and create a setting named
# WEBSITES_PORT with a value that matches the port here (the Azure default is 80).
# You can also create a setting through the App Service Extension in VS Code.
ENV LISTEN_PORT=8000
EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
ADD requirements.txt .
RUN python -m pip install -r requirements.txt

# Tell nginx where static files live. Typically, developers place static files for
# multiple apps in a shared folder, but for the purposes here we can use the one
# app's folder. Note that when multiple apps share a folder, you should create subfolders
# with the same name as the app underneath "static" so there aren't any collisions
# when all those static files are collected together, as when using Django's
# collectstatic command.
ENV STATIC_URL /app/static

WORKDIR /app
ADD . /app

# Make app folder writeable for the sake of db.sqlite3, and make that file also writeable.
# Ideally you host the database somewhere else so that the app folders can remain read only.
# Without these permissions you see the errors "unable to open database file" and
# "attempt to write to a readonly database", respectively, whenever the app attempts to
# write to the database.
RUN chmod g+w /app

#RUN chmod g+w /app/db.sqlite3

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN useradd appuser && chown -R appuser /app
USER appuser

# Collect all static files for our app
RUN python manage.py collectstatic

# Make migrations for our DB objects
RUN python manage.py makemigrations

# Migrate all changes to db objects
RUN python manage.py migrate

# Run the server -DEBUG MODE
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
# File wsgi.py was not found in subfolder: 'python-django-template'. Please enter the Python path to wsgi file.
CMD ["gunicorn", "--bind", "0.0.0:8000", "--workers", "3", "web_project.wsgi"]
