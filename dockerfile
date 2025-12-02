FROM php:8.4-cli

# Instalar extensiones necesarias para Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

RUN composer install --optimize-autoloader --no-scripts
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
