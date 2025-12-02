FROM php:8.4-cli

# Instalar extensiones necesarias para Laravel y Composer
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Regenerar lock file con PHP 8.4
RUN composer update --no-scripts --optimize-autoloader

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
