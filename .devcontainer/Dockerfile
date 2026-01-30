FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql nodejs npm \
    && apt-get clean

# Устанавливаем pnpm глобально
RUN npm install -g pnpm
RUN a2enmod rewrite
