FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Устанавливаем Node.js и NPM из репозиториев Ubuntu
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql nodejs npm \
    && apt-get clean

# Включаем Corepack (он уже идет с Node.js) и активируем pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Модуль Apache
RUN a2enmod rewrite
