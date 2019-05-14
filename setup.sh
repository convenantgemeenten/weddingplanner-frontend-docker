#!/bin/bash

cd /var/www/html
composer install --no-plugins --no-scripts
if [ ! -f ".env" ]; then
    mv .env.example .env
    php artisan key:generate
fi
chmod -R 777 /var/www/html/storage