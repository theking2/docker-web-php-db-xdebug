# syntax=docker/dockerfile:1

# Source image (update php version when needed)
FROM php:8.3.12-apache

# PHP ini path for upload config
ARG UPLOADS_INI="/usr/local/etc/php/conf.d/uploads.ini"

# Enable mod_rewrite, install dependencies, PHP extensions, and xdebug in one layer
# Clean up apt cache to reduce image size
RUN a2enmod rewrite \
    && apt-get update \
    && apt-get install -y --no-install-recommends libmariadb-dev \
    && docker-php-ext-install mysqli pdo_mysql \
    && docker-php-ext-enable mysqli pdo_mysql \
    && printf "upload_max_filesize = 128M\npost_max_size = 128M\n" > "${UPLOADS_INI}" \
    && pecl install xdebug-3.4.1 \
    && docker-php-ext-enable xdebug \
    && apt-get purge -y --auto-remove libmariadb-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/pear

USER www-data
