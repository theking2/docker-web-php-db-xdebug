# setup for a complete lamp with xdebug

1. Download the repositorys ZIP-file
2. Create a project folder (this will contain the Webservers root `htdocs` and the server root (`server`) .
3. Unzip the repo in a subfolder and rename it `server`

The last step is not really needed but makes it a bit better readable. The folder structure at the end is:

```
projectname
├── htdocs <-- root of the webser er
├── logs
└── server
```


* localhost:9080/ => ./htdocs as webroot folder
* localhost:9081/  => adminer
* localhost:9306 => external db connection (only needed for external access

> \[!NOTE]
> from _inside_ the network the database connection is db:3306!!

> \[!NOTE]
> A configured `xdebug.ini` file sits in the `server` folder. It defaults to allow step debugging. After changing make sure to restart the webserver!


## Setup docker containers

### With Containers VSCode extension

1) Install VScode extension "Container Tools"
2) Update `.env` file (Setting network and Project)
3) Open `compose.yaml` file and click "Run All Services"
4) Copy or move the folder and content `.vscode` to the root of the project


### Without extension

1) Adapt `.env` to set the project and network name. 
2) change `MARIADB_ROOT_PASSWORD` first time creation. After that it is fixed. So after generation of the containers you can (should) return it to its original or some other value

When you're ready, start your application by running:
`docker compose up --build`.

## Setup php xdebug

* Install xdebug extension
* Move the folder `.vscode` to the root of the project. This folder contains the setup for the VSCode PHP debugger (`launch.json`).

### in detail

The copied launch.json contains settings so that the PHP Debug extension sees root of the webserver at `htdocs`:

```js
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/htdocs"
            }
```

## Setup Webserver

Move the folder `htdocs` including its content to the root of the project folder.

## Setup database

To create a database and a user open in Adminer oder a vscode MariaDB plugin

```sql
create database my_database;
create user 'my-user'@'%' identified by 'my-password';
grant all privileges on my_database.* to 'my-user'@'%';
flush privileges;
```
