#!/bin/bash

cd /var/www/html
export COMPOSER_ALLOW_SUPERUSER=1 # liever niet, maar de demo moet wel even werken dadelijk....
composer install
if [ ! -f ".env" ]; then
    mv .env.example .env
    php artisan key:generate
fi
chmod -R 777 /var/www/html/storage