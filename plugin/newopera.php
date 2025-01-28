<?php
/**
 * Plugin Name: New Opera Company Site Plugin
 * Plugin URI: https://github.com/varilink/newopera-wordpress
 * Description: Adds custom panels to the post editor for production post types.
 * Version: 0.1.0
 * Author: David Williamson @ Varilink Computing Ltd
 * Test Domain: newopera
 */

defined( 'ABSPATH' ) || exit;

require( __DIR__ . '/past-production/past-production.php' );
require( __DIR__ . '/upcoming-production/upcoming-production.php' );
