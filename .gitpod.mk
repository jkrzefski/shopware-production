SHELL := /bin/bash

.PHONY: prebuild
prebuild:
	composer install
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"
	cp .gitpod/.env.dist .env
	echo "COMPOSER_HOME=\"`pwd`/var/cache/composer\"" >> .env
	bin/console system:install --create-database --skip-jwt-keys-generation
	bin/console user:create --admin --password="shopware" -- "admin"
	bin/console system:config:set core.frw.completedAt "`date +%FT%T`+00:00"

.PHONY: init
init:
	echo "APP_URL=\"`bin/console gp:url:port 8000`\"" >> .env
	echo "APP_SECRET=\"`bin/console system:generate-app-secret`\"" >> .env
	echo "INSTANCE_ID=\"`openssl rand -base64 24`\"" >> .env
	bin/console system:generate-jwt
	bin/console sales-channel:create:storefront --name="Storefront" --url="`bin/console gp:url:port 8000`"
	bin/console theme:change --all -- "Storefront"
	bin/console system:update:finish
	bin/console cache:clear
	symfony server:start --no-tls -d
