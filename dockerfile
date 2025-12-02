FROM php:8.4-fpm

# Instalar extensiones necesarias para Laravel
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    zip \
    libzip-dev \
    nginx \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorios necesarios
RUN mkdir -p /var/www/html /var/log/supervisor

WORKDIR /var/www/html
COPY . .

# Instalar dependencias Laravel
RUN composer install --optimize-autoloader --no-scripts --no-interaction

# Copiar configuración de Nginx y Supervisor
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exponer el puerto que Railway asigna
EXPOSE 8080

# Iniciar Nginx y PHP-FPM con Supervisor
CMD ["/usr/bin/supervisord"]

ENV PORT=8080