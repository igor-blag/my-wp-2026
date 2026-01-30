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


# 5. Определение путей (максимально надежно)
# Если переменная пуста, используем стандартный путь
WORKSPACE_PATH=${CONTAINER_WORKSPACE_FOLDER:-"/workspaces/my-wp-2026"}
MY_PLUGINS_DIR="$WORKSPACE_PATH/plugins"

echo "Ищу плагины в: $MY_PLUGINS_DIR"

# Создаем папку, если её нет
mkdir -p "$MY_PLUGINS_DIR"

# 6. Проверка: а есть ли там вообще что-то?
if [ -z "$(ls -A $MY_PLUGINS_DIR)" ]; then
   echo "ВНИМАНИЕ: Папка $MY_PLUGINS_DIR пуста. Нечего связывать!"
fi

# 7. Создание ссылок
for plugin_path in "$MY_PLUGINS_DIR"/*; do
    if [ -d "$plugin_path" ]; then
        plugin_name=$(basename "$plugin_path")
        echo "Создаю ссылку для плагина: $plugin_name"
        sudo ln -snf "$plugin_path" /var/www/html/wp-content/plugins/"$plugin_name"
    fi
done

# 8. Права доступа (в самом конце)
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
# Даем Apache право читать файлы из репозитория
sudo usermod -aG vscode www-data
chmod -R 755 "$WORKSPACE_PATH"