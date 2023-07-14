<?php
/*
Plugin Name: Varilink Site Plugin
Plugin URI: https://github.com/varilink/newopera-wordpress
Description: Varilink site plugin for New Opera Company WordPress website.
*/

add_action( 'init', function () {
    $labels = array(
        'name' => _x( 'Past Productions', 'post type general name' ),
        'singular_name'
            => _x( 'Past Production', 'post type singular name' ),
    );
    $args = array(
        'labels' => $labels,
        'public' => true,
        'menu_icon' => 'dashicons-archive',
        'show_in_rest' => true,
        'has_archive' => 'past-productions',
        'supports' => array( 'title', 'editor', 'excerpt', 'thumbnail' ),
    );
    register_post_type('past-production', $args);
});

add_action( 'init', function () {
    $labels = array(
        'name' => _x( 'Upcoming Productions', 'post type general name' ),
        'singular_name'
            => _x( 'Upcoming Production', 'post type singular name'),
    );
    $args = array(
        'labels' => $labels,
        'public' => true,
        'menu_icon' => 'dashicons-calendar-alt',
        'show_in_rest' => true,
        'supports' => array( 'title', 'editor', 'excerpt', 'thumbnail' ),
    );
    register_post_type('upcoming-production', $args);
});

?>
