# Base image - Ubuntu 18.04
FROM ubuntu:18.04
ENV TERM linux
ENV DEBIAN_FRONTEND=noninteractive 

MAINTAINER Berend Iwema <b.iwema@middendrenthe.nl>, Mark van der Straten <m.vanderstraten@middendrenthe.nl>

# NL mirror gebruiken
RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1nl.\2/" /etc/apt/sources.list

# Updaten
RUN apt-get update \
	 && apt-get install -y apt-transport-https ca-certificates \
	 && apt-get install -y language-pack-en-base software-properties-common apt-utils

# Locales generaten
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# PPA van ondrej toevoegen
RUN apt-get install -y software-properties-common \
 && apt-add-repository ppa:ondrej/php
RUN apt-get update

# Installeren PHP 7.3 en nginx
RUN apt-get install -y \
    build-essential \
    supervisor \
    curl \
    git \
    apache2 \
    php7.3 \
    php7.3-bcmath \
    php7.3-bz2 \
    php7.3-cgi \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-dba \
    php7.3-dev \
    php7.3-enchant \
    php7.3-gd \
    php7.3-gmp \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-opcache \
    php7.3-pgsql \
    php7.3-phpdbg \
    php7.3-soap \
    php7.3-tidy \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-xsl \
    php7.3-zip \
    php7.3-fpm \
    php-memcached \
    composer \
    php-memcache \
    php-apcu \
    libpcre3-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    vim \
    sudo \
    nginx

# Instance cleanen
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Memory usage limiteren voor stabiliteit
CMD ulimit -n 1536

# Configuratie van nginx, PHP-FPM en supervisord
COPY nginx_site_default /etc/nginx/sites-available/default
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.3/fpm/php.ini && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php
 
# Volumes
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Setup
COPY setup.sh /setup.sh
CMD ["./setup.sh"]


# Services starten
COPY start.sh /start.sh
CMD ["./start.sh"]


# Poorten openen
EXPOSE 80

