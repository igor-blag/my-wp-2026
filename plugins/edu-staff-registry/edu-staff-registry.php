function edu_staff_registry_block_init() {
    register_block_type( __DIR__ . '/build' );
}
add_action( 'init', 'edu_staff_registry_block_init' );