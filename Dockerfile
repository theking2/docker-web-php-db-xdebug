# syntax=docker/dockerfile:1

# Source image (update php version when needed)
FROM php:8.5-apache

# PHP ini path for upload config
ARG UPLOADS_INI="/usr/local/etc/php/conf.d/uploads.ini"

# Enable mod_rewrite, install dependencies, PHP extensions, and xdebug in one layer
# Clean up apt cache to reduce image size
RUN a2enmod rewrite \
    && apt-get update \
    && apt-get install -y --no-install-recommends libmariadb-dev \
    && docker-php-ext-install mysqli pdo_mysql \
    && docker-php-ext-enable mysqli pdo_mysql \
    && printf "upload_max_filesize = 512M\npost_max_size = 512M\n" > "${UPLOADS_INI}" \
    && pecl install xdebug-3.5.0 \
    && docker-php-ext-enable xdebug \
    && apt-get purge -y --auto-remove libmariadb-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/pear

# Run Apache with the host user's uid/gid so files written to the bind mounts
# (inc/, _db_sp_func/, logs/) belong to the developer and need no chmod 777
ARG UID=1000
ARG GID=1000
RUN groupmod -o -g "${GID}" www-data \
    && usermod -o -u "${UID}" -g "${GID}" www-data

USER www-data
