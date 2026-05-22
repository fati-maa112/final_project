#!/bin/sh
set -e

echo "==> Creating nginx directories..."
mkdir -p /etc/nginx/conf.d
mkdir -p /var/log/nginx
mkdir -p /run/nginx

echo "==> Copying nginx config..."
cp /var/www/html/nginx-main.conf /etc/nginx/nginx.conf
cp /var/www/html/nginx.conf /etc/nginx/conf.d/default.conf

echo "==> Running migrations..."
php bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration || true

echo "==> Warming up cache..."
php bin/console cache:warmup --env=prod || true

echo "==> Starting PHP-FPM..."
php-fpm -D

echo "==> Starting Nginx..."
nginx -g 'daemon off;'