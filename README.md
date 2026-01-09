# setup for a complete lamp with xdebug

* localhost:9080/ => ./htdocs as webroot folder
* localhost:9081/  => adminer
* localhost:9306 => external db connection (only needed for external access

> **_NOTE:_**  from inside the network the database connection is db:3306!!

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

## Setup xdebug launch.json

The `xdebug.ini` file sits in the root. After changing make sure to restart the webserver!

* Install xdebug extension
* create launch.json (open the xdebug tab and click "create a launch.json file" )
* add thist to the configurations section in the launnch.json file (for instance just below the port: 9003 section)

```js
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/htdocs"
            }
```

and save the file. This assumes you have your webroot in a folder htdocs as indicated above.

## Setup database

To create a database and a user open in Adminer oder a vscode MariaDB plugin

```sql
create database my_database;
create user 'my-user'@'%' identified by 'my-password';
grant all privileges on my_database.* to 'my-user'@'%';
flush privileges;
```
