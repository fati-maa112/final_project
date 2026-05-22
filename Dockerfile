FROM php:8.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache nginx git zip unzip bash

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-dev --optimize-autoloader

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
