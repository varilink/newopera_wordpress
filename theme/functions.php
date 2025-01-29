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

function convert_to_json_safe_string( $input ) {

    // Encode the string to JSON, which escapes newlines, quotes, etc.
    $json_safe = json_encode( $input );
    return $json_safe;

}


add_action('init', function () {

    register_block_pattern_category(
        'newopera',
        array( 'label' => 'New Opera Company, Derby', 'slug' => 'newopera' )
    );

    $banner = <<<END
<!-- wp:group {"layout":{"type":"constrained"}} -->
<div class="wp-block-group">

    <!-- wp:group {"align":"wide","style":{"spacing":{"padding":{"right":"var:preset|spacing|30","left":"var:preset|spacing|30"}}},"layout":{"type":"flex","flexWrap":"nowrap","justifyContent":"space-between"}} -->
    <div class="wp-block-group alignwide" style="padding-right:var(--wp--preset--spacing--30);padding-left:var(--wp--preset--spacing--30)">

        <!-- wp:site-logo {"width":480,"shouldSyncIcon":false} /-->
        <!-- wp:navigation {"ref":25} /-->

    </div>
    <!-- /wp:group -->

</div>
<!-- /wp:group -->
END;

    

} );

?>
