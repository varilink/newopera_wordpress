<?php

add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'newopera-site-style', get_stylesheet_directory_uri() . '/style.css'
    );
    if ( is_front_page() ) {
        $my_query = new WP_Query(
            array('post_type' => 'upcoming-production')
        );
        if ( ! $my_query -> have_posts() ) {
            wp_add_inline_style(
                'newopera-site-style',
                '.upcoming-productions{display:none}'
            );
        }
    }
});

?>
