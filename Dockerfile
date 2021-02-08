# composer container image version
ARG COMPOSER_VERSION=latest
# php container image version
ARG PHP_VERSION=8-apache

################################################################################
# Stage 1: composer
################################################################################
FROM composer:${COMPOSER_VERSION} AS composer

ARG ENVAULT_VERSION=v2.4.0

# Download envault from GitHub & extract it
RUN curl -L https://github.com/envault/envault/archive/$ENVAULT_VERSION.tar.gz -o- -s \
	| tar -xvzf- --strip 1

RUN composer install



################################################################################
# Stage 2: production container
################################################################################
FROM php:${PHP_VERSION}

# Add custom entrypoint
ADD docker-envault-entrypoint.sh /usr/local/bin/docker-envault-entrypoint
ENTRYPOINT [ "/usr/local/bin/docker-envault-entrypoint" ]
CMD apache2-foreground

# Install dependencies
RUN apt-get update \
	&& apt-get install -y default-mysql-client \
	&& rm -rf /var/lib/apt/lists/*
# Install & activate extensions required by Laravel
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable Apache rewrite module
RUN ln -s ../mods-available/rewrite.load /etc/apache2/mods-enabled
# Patch Apache config
ADD apache2.conf /etc/apache2/apache2.conf
# Patch Apache default site config
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

# Set workdir
WORKDIR /var/www/envault/
# Copy source files & dependencies from the composer stage
COPY --from=composer /app .
# Fix permissions of writable directories
RUN chown -R www-data:www-data storage bootstrap/cache
