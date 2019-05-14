#!/bin/bash

cd /var/www/html
sudo -u www-data composer install
if [ ! -f ".env" ]; then
    mv .env.example .env
    php artisan key:generate
fi
chmod -R 777 /var/www/html/storage