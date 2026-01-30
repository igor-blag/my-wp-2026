# Используем Ubuntu 24.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# 1. Установка системных пакетов
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql nodejs npm git-lfs \
    && apt-get clean

# 2. Установка pnpm через обычный npm (так надежнее в этой версии Ubuntu)
RUN npm install -g pnpm

# 3. Включаем модуль Apache для красивых ссылок
RUN a2enmod rewrite