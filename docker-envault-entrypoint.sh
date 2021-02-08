#!/bin/sh
set -e

################################################################################
# Generate APP_KEY, if variable is not set
################################################################################
if [ -z "$var" ]
then
	# Create a placeholder in .env
	echo APP_KEY= > .env
	# Generate key
	php artisan key:generate -q
	echo "**************************************\n*     Application Key Generated!     *\n**************************************"
	# Print APP_KEY
	cat .env
fi

################################################################################
# Run migrations
################################################################################
echo yes | php artisan migrate

################################################################################
# Call the original entrypoint and pass all variables
################################################################################
docker-php-entrypoint "$@"