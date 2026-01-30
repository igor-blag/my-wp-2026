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


# Путь к твоим плагинам в репозитории
MY_PLUGINS_DIR="/workspaces/${PWD##*/}/plugins"

# Создаем папку, если её нет
mkdir -p "$MY_PLUGINS_DIR"

# Даем права Apache
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Проходим по всем папкам внутри /plugins
for plugin_path in "$MY_PLUGINS_DIR"/*; do
    # Проверяем, что это папка, а не файл
    if [ -d "$plugin_path" ]; then
        plugin_name=$(basename "$plugin_path")
        echo "Linking plugin: $plugin_name"
        # -s (символическая), -n (не переходить по ссылке), -f (принудительно обновить)
        sudo ln -snf "$plugin_path" /var/www/html/wp-content/plugins/"$plugin_name"
    fi
done
