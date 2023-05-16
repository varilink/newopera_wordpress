<?php

if ( ! function_exists('varilink_enqueue_styles') ) {
    function varilink_enqueue_styles() {
        wp_enqueue_style(
            'theme_style', get_stylesheet_directory_uri() . '/style.css'
        );
    }
    add_action('wp_enqueue_scripts', 'varilink_enqueue_styles');
}

?>
