FROM php:8.1-apache

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    cron \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libonig-dev \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql xml mbstring zip intl

# Copia o crontab para dentro do container
COPY crontab.txt /etc/cron.d/elgg-cron

# Dá permissão correta para o arquivo de cron
RUN chmod 0644 /etc/cron.d/elgg-cron

# Registra o cron job
RUN crontab /etc/cron.d/elgg-cron

# Habilita o mod_rewrite
RUN a2enmod rewrite

RUN mkdir /opt/data

# Expondo a porta do apache
EXPOSE 80

# Comando para iniciar Apache + Cron juntos
CMD service cron start && apache2-foreground

