<?php
/**
 * Plugin Name: Edu Staff Registry
 * Description: Тестовый плагин для обучения 2026.
 * Version: 1.0
 * Author: Igor
 */

// Защита от прямого доступа к файлу
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Подключаем наш скомпилированный скрипт
 */
function edu_staff_enqueue_scripts() {
    // Автоматически определяем путь к файлу в нашей папке
    $script_url = plugins_url( 'build/index.js', __FILE__ );
    
    // Подключаем скрипт
    wp_enqueue_script(
        'edu-staff-script',  // Уникальное название (handle)
        $script_url,         // Ссылка на файл
        array(),             // Зависимости (пока пусто)
        '1.0',               // Версия
        true                 // Загрузить в футере (перед </body>)
    );
}

// Привязываем нашу функцию к событию (хуку) загрузки скриптов на сайте
add_action( 'wp_enqueue_scripts', 'edu_staff_enqueue_scripts' );