# Use the official Microsoft Dev Container image with Ubuntu 24.04
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install system dependencies: Apache, MySQL, PHP, and Node.js
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql nodejs npm git-lfs \
    && apt-get clean

# Install pnpm globally for efficient package management
RUN npm install -g pnpm

# Enable Apache rewrite module for WordPress permalinks
RUN a2enmod rewrite