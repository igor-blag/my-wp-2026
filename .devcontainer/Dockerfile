# Берем официальный образ Ubuntu 24.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Устанавливаем всё, что мы ставили руками, одной командой
# Мы объединяем команды через &&, чтобы контейнер был "легче"
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql nodejs npm \
    && apt-get clean

# Включаем модуль rewrite, который мы включали руками
RUN a2enmod rewrite
