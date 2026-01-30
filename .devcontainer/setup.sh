#!/bin/bash

# 1. Запускаем службы (они нужны для настройки базы)
sudo service mysql start
sudo service apache2 start

# 2. Настройка базы данных
# Мы используем -e для выполнения команды сразу
sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY '12345';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 3. Скачивание и установка WordPress (если его еще нет)
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Скачиваю WordPress..."
    cd /tmp
    curl -O https://wordpress.org/latest.tar.gz
    tar -xvf latest.tar.gz
    sudo rm /var/www/html/index.html
    sudo cp -r wordpress/* /var/www/html/
fi

# 4. Создание wp-config.php с нашими правками
# Мы используем 'cat' для записи многострочного файла
sudo tee /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', 'wordpress' );
define( 'DB_USER', 'wp_user' );
define( 'DB_PASSWORD', '12345' );
define( 'DB_HOST', '127.0.0.1' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// Тот самый Proxy Fix для стилей
if (isset(\$_SERVER['HTTP_X_FORWARDED_HOST'])) {
    \$_SERVER['HTTP_HOST'] = \$_SERVER['HTTP_X_FORWARDED_HOST'];
}
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    \$_SERVER['HTTPS'] = 'on';
}
define('WP_HOME', 'https://' . \$_SERVER['HTTP_HOST']);
define('WP_SITEURL', 'https://' . \$_SERVER['HTTP_HOST']);

\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

# 5. Права доступа
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Создаем папку для плагина в репозитории, если её нет
mkdir -p /workspaces/my-wp-2026/my-plugin

# Создаем "портал" (симлинк) из папки плагинов WordPress в твой репозиторий
sudo ln -s /workspaces/my-wp-2026/my-plugin /var/www/html/wp-content/plugins/my-plugin
