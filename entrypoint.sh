#!/bin/sh
set -e

echo "==> Creating nginx directories..."
mkdir -p /etc/nginx/conf.d
mkdir -p /var/log/nginx
mkdir -p /run/nginx

echo "==> Copying nginx config..."
cp /var/www/html/nginx-main.conf /etc/nginx/nginx.conf
cp /var/www/html/nginx.conf /etc/nginx/conf.d/default.conf

echo "==> Waiting for database to be ready..."
until php bin/console doctrine:query:sql 'SELECT 1' > /dev/null 2>&1; do
  echo "Waiting for database..."
  sleep 3
done

echo "==> Running migrations..."
php bin/console doctrine:migrations:migrate --no-interaction

echo "==> Warming up cache..."
php bin/console cache:warmup --env=prod

echo "==> Starting PHP-FPM..."
php-fpm -D

echo "==> Starting Nginx..."
nginx -g 'daemon off;'