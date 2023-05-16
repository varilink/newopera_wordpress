# ------------------------------------------------------------------------------
# init.sh
# ------------------------------------------------------------------------------

wp option update permalink_structure '/%postname%/'

wp option update uploads_use_yearmonth_folders 0

for image in footer-logo header-logo
do

  for post in $(                                                               \
    wp post list --post_type=attachment --fields=ID,name --format=json |       \
    jq ".[] | select(.post_name | contains(\"$image\")) | .ID"                 \
  )
  do

    wp post delete $post --force

  done

  id=`wp media import /wordpress/gimp/dest/$image.webp --porcelain`

  if [ "$image" == 'header-logo' ]
  then

    wp option update site_logo $id

  fi

done

wp option update uploads_use_yearmonth_folders 1

wp theme activate varilink-site-theme

wp plugin activate varilink-site-plugin

wp option update show_on_front page

wp option update page_on_front                                                 \
  `wp post list --post_type=page --field=ID --post_name=home-page`
