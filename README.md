# Python/Django Tutorial Sample for VS Code

* This sample contains the completed program from the tutorial [Using Django in Visual Studio Code](https://code.visualstudio.com/docs/python/tutorial-django). Intermediate steps are not included.

To run the sample:

1. In VS Code Terminal, run `python -m venv env` to create a virtual environment as described in the tutorial.
2. Press Ctrl + Shift + P and run command `Python: Select Interpreter`. If possible, select the interpreter ending with "('env': venv)"
3. Activate the virtual environment by running `env/scripts/activate` if you are on Windows or run `source env/bin/activate` if you are on Linux/MacOS.
4. In terminal, run `pip install django`.
5. Create and initialize the database by running `python manage.py migrate`.
6. From Run and Debug section, select `Python: Django` launch configuration and hit F5.

* For steps on running this app in a Docker container, see [Python in containers](https://code.visualstudio.com/docs/containers/quickstart-python) on the VS Code Docs website.

# Known issues

- CSS is lost if you set `DEBUG=False` in settings.py; the workaround is to include an added script at the end of dockerfile.txt to serve static file differently. See [Issue 13](https://github.com/Microsoft/python-sample-vscode-django-tutorial/issues/13) for details.

# Contributing

Contributions to the sample are welcome. When submitting changes, also consider submitting matching changes to the tutorial's source file [tutorial-django.md](https://github.com/Microsoft/vscode-docs/blob/master/docs/python/tutorial-django.md).

Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and willingly choose to, grant us the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

## Additional details

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
~This is empty~


Steps to setup Django web app : https://github.com/microsoft/python-sample-vscode-django-tutorial/tree/tutorial

Running Python application in a container
Reference:
*https://code.visualstudio.com/docs/containers/quickstart-python
*https://code.visualstudio.com/docs/containers/overview#_installation
___________________________________________________________________________________________________________________________________________________________________________

Django settings 
references: https://docs.djangoproject.com/en/2.1/topics/settings/#envvar-DJANGO_SETTINGS_MODULE
			https://github.com/MattSegal/django-deploy
___________________________________________________________________________________________________________________________________________________________________________

A) Setup application to work with both prod and dev settings
___________________________________________________________________________________________________________________________________________________________________________

1) create folder in manin app called settings
2) create a python file (.py) named prod.py and dev.py
3) rename settings.py to base.py
4) paste this in prod.pyc

set DJANGO_SETTINGS_MODULE=mysite.settings.dev
set DJANGO_SETTINGS_MODULE=mysite.settings.prod

B) Setup Environment
___________________________________________________________________________________________________________________________________________________________________________

1) In VS Code Terminal, run `python -m venv env` to create a virtual environment as described in the tutorial.
2) Press Ctrl + Shift + P and run command `Python: Select Interpreter`. If possible, select the interpreter ending with "('env': venv)"
3) Activate the virtual environment by running `env/scripts/activate` if you are on Windows or run `source env/bin/activate` if you are on Linux/MacOS.
4) In terminal, run `pip install django`.
5) Create and initialize the database by running `python manage.py migrate`.
6) From Run and Debug section, select `Python: Django` launch configuration and hit F5.

B) Migrations References: https://simpleisbetterthancomplex.com/tutorial/2016/07/26/how-to-reset-migrations.html
___________________________________________________________________________________________________________________________________________________________________________

Scenario 1:
The project is still in the development environment and you want to perform a full clean up. You don’t mind throwing the whole database away.
1) Remove the all migrations files within your project
Go through each of your projects apps migration folder and remove everything inside, except the __init__.py file.
Or if you are using a unix-like OS you can run the following script (inside your project dir):
--find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
--find . -path "*/migrations/*.pyc"  -delete
2) Drop the current database, or delete the db.sqlite3 if it is your case.
3) Create the initial migrations and generate the database schema:
--python manage.py makemigrations
--python manage.py migrate
--python manage.py collectstatic

Scenario 2:
You want to clear all the migration history but you want to keep the existing database.

1) Make sure your models fits the current database schema
The easiest way to do it is trying to create new migrations:
--python manage.py makemigrations

If there are any pending migration, apply them first.
If you see the message:
--No changes detected
You are good to go.

2) Clear the migration history for each app
Now you will need to clear the migration history app by app.

First run the showmigrations command so we can keep track of what is going on:
--python manage.py showmigrations
Result:

admin
 [X] 0001_initial
 [X] 0002_logentry_remove_auto_add
auth
 [X] 0001_initial
 [X] 0002_alter_permission_name_max_length
 [X] 0003_alter_user_email_max_length
 [X] 0004_alter_user_username_opts
 [X] 0005_alter_user_last_login_null
 [X] 0006_require_contenttypes_0002
 [X] 0007_alter_validators_add_error_messages
contenttypes
 [X] 0001_initial
 [X] 0002_remove_content_type_name
core
 [X] 0001_initial
 [X] 0002_remove_mymodel_i
 [X] 0003_mymodel_bio
sessions
 [X] 0001_initial

Clear the migration history (please note that core is the name of my app):
--python manage.py migrate --fake core zero
The result will be something like this:

Operations to perform:
  Unapply all migrations: core
Running migrations:
  Rendering model states... DONE
  Unapplying core.0003_mymodel_bio... FAKED
  Unapplying core.0002_remove_mymodel_i... FAKED
  Unapplying core.0001_initial... FAKED
  
Now run the command showmigrations again:
--python manage.py showmigrations
Result:

admin
 [X] 0001_initial
 [X] 0002_logentry_remove_auto_add
auth
 [X] 0001_initial
 [X] 0002_alter_permission_name_max_length
 [X] 0003_alter_user_email_max_length
 [X] 0004_alter_user_username_opts
 [X] 0005_alter_user_last_login_null
 [X] 0006_require_contenttypes_0002
 [X] 0007_alter_validators_add_error_messages
contenttypes
 [X] 0001_initial
 [X] 0002_remove_content_type_name
core
 [ ] 0001_initial
 [ ] 0002_remove_mymodel_i
 [ ] 0003_mymodel_bio
sessions
 [X] 0001_initial
 
You must do that for all the apps you want to reset the migration history.

3) Remove the actual migration files.
Go through each of your projects apps migration folder and remove everything inside, except for the __init__.py file.

Or if you are using a unix-like OS you can run the following script (inside your project dir):

find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc"  -delete
PS: The example above will remove all the migrations file inside your project.

4) Run the showmigrations again:
--python manage.py showmigrations
Result:

admin
 [X] 0001_initial
 [X] 0002_logentry_remove_auto_add
auth
 [X] 0001_initial
 [X] 0002_alter_permission_name_max_length
 [X] 0003_alter_user_email_max_length
 [X] 0004_alter_user_username_opts
 [X] 0005_alter_user_last_login_null
 [X] 0006_require_contenttypes_0002
 [X] 0007_alter_validators_add_error_messages
contenttypes
 [X] 0001_initial
 [X] 0002_remove_content_type_name
core
 (no migrations)
sessions
 [X] 0001_initial
 
5) Create the initial migrations
--python manage.py makemigrations
Result:

Migrations for 'core':
  0001_initial.py:
    - Create model MyModel
	
6) Fake the initial migration
In this case you won’t be able to apply the initial migration because the database table already exists. What we want to do is to fake this migration instead:
--python manage.py migrate --fake-initial
Result:

Operations to perform:
  Apply all migrations: admin, core, contenttypes, auth, sessions
Running migrations:
  Rendering model states... DONE
  Applying core.0001_initial... FAKED
  
7) Run showmigrations again:
--python manage.py showmigrations

admin
 [X] 0001_initial
 [X] 0002_logentry_remove_auto_add
auth
 [X] 0001_initial
 [X] 0002_alter_permission_name_max_length
 [X] 0003_alter_user_email_max_length
 [X] 0004_alter_user_username_opts
 [X] 0005_alter_user_last_login_null
 [X] 0006_require_contenttypes_0002
 [X] 0007_alter_validators_add_error_messages
contenttypes
 [X] 0001_initial
 [X] 0002_remove_content_type_name
core
 [X] 0001_initial
sessions
 [X] 0001_initial
And we are all set up :-)

D) SuperUser Reference: https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django/Admin_site
___________________________________________________________________________________________________________________________________________________________________________

1) python manage.py createsuperuser
--Enter username
--Enter email
--Enter password
--Enter password again

E) Whitenoise - used to render static files while in production and dev (for consistency)
*reference: http://whitenoise.evans.io/en/stable/

1) Add: whitenoise to requirements.txt
2) run: pip install -r .\requirements.txt
3) run: pip list -> to ensure its installed
4) add: 'whitenoise.middleware.WhiteNoiseMiddleware', to the MIDDLEWARE property in the settings file
*IMPORTANT: add the above line after this line: 'django.middleware.security.SecurityMiddleware',
5) add: 'whitenoise.runserver_nostatic', to INSTALLED_APPS property in the settings file
*IMPORTANT: add it as the first line
6) add: STATIC_ROOT = os.path.join(BASE_DIR, 'static_collected') to prod settings file
7) run: python manage.py collectstatic

F) SQLite
___________________________________________________________________________________________________________________________________________________________________________

1) install sqlite3 from: https://www.sqlite.org/download.html 
	get the: Precompiled Binaries for Windows -> A bundle of command-line tools for managing SQLite database files, including the command-line shell program, the sqldiff.exe program, and the sqlite3_analyzer.exe program.
	
GOOD TO KNOW:
*remove 1st line in manage.py file (#!/usr/bin/env python) in order for manage.py commands to work on windows