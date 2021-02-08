#!/bin/sh
set -e

# php artisan key:generate
echo yes | php artisan migrate

docker-php-entrypoint "$@"