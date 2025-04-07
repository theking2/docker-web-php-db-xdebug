# setup for a complete lamp with xdebug

* localhost:9080/ => ./htdocs as webroot folder
* localhost:9081/  => adminer

## Setup docker containers

change `MARIADB_ROOT_PASSWORD` first time creation. After that it is fixed. So after generation of the containers you can (should) return it to its original or some other value

When you're ready, start your application by running:
`docker compose up --build`.

## Setup xdebug launch.json

* Install xdebug extension
* create launch.json (open the xdebug tab and click "create a launch.json file" )
* add thist to the configurations section in the launnch.json file (for instance just below the port: 9003 section)

```js
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}/htdocs"
            }
```

and save the file. This assumes you have your webroot in a folder htdocs as indicated above.
