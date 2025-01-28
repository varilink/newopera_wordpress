<?php

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly.
}

// Post type

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

// Post meta

add_action( 'init', function () {
    $metafields = [
        '_past_production_start_date', '_past_production_end_date'
    ];
    foreach ( $metafields as $metafield ) {
        register_post_meta (
            'past-production',
            $metafield,
            array (
                'show_in_rest' => true,
                'type' => 'string',
                'single' => true,
                'auth_callback' => function() { 
                    return current_user_can( 'edit_posts' );
                }
            )
        );
    }
} );

// Post columns

add_filter('manage_past-production_posts_columns', function ($original) {
    $inserted = [
        'past_production_start_date' => __('Start Date', 'textdomain'),
    ];
    $original['date'] = __('Post Date', 'textdomain');
    return array_merge(
        array_slice($original, 0, 2),
        $inserted,
        array_slice($original, 2)
    );
});

add_action(
    'manage_past-production_posts_custom_column',
    function ($column_key, $post_id) {
        if ($column_key == 'past_production_start_date') {
            $past_production_start_date = get_post_meta(
                $post_id, '_past_production_start_date', true
            );
            if ( $past_production_start_date ) {
                $start_date = DateTime::createFromFormat(
                    'Y-m-d', $past_production_start_date
                );
                echo $start_date->format('d/m/Y');
            }
        }
    },
    10,
    2
);

add_filter(
    'manage_edit-past-production_sortable_columns',
    function ($sortable_columns) {
        $sortable_columns['past_production_start_date']
            = '_past_production_start_date';
        return $sortable_columns;
    }
);

add_action('pre_get_posts', function($query) {

    if ( $query->is_post_type_archive('past-production') ) {

        if ( is_admin() ) {

            $orderby = $query->get('orderby');

            if ( '_past_production_start_date' === $orderby ) {
                $query->set('meta_key', '_past_production_start_date');
                $query->set('orderby', 'meta_value');
            }

        } elseif ( $query->is_main_query() ) {

            $query->set('meta_key', '_past_production_start_date');
            $query->set('orderby', 'meta_value');
            $query->set('posts_per_page', 4);

        }

    }

});

add_action(
    'enqueue_block_editor_assets', function() {

        $screen = get_current_screen();

        if (
            $screen && $screen->post_type === 'past-production'
        ) {

            wp_enqueue_script(
                'past-production',
                plugin_dir_url( __FILE__ ) . 'build/index.js',
                array( 'wp-edit-post' )
            );
        }

    }
);
