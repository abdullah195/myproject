CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "8000"]


# Base image
FROM php:8.0-apache

# Set the working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        unzip \
        git && \
    docker-php-ext-install zip && \
    a2enmod rewrite

# Copy the project files to the working directory
COPY . /var/www/html

# Set permissions for Laravel storage and bootstrap cache
RUN chown -R www-data:www-data \
    /var/www/html/storage \
    /var/www/html/bootstrap/cache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install project dependencies using Composer
RUN composer install --no-interaction --no-scripts --no-suggest

# Generate the Laravel application key
RUN php artisan key:generate

# Expose port 80
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
