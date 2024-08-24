# ------------------------------------------------------------------------------
# wp-cli-scripts/init.sh
# ------------------------------------------------------------------------------

set -e

# ------------------------------
# Update the permalink structure
# ------------------------------

wp rewrite structure '/%postname%/'
wp rewrite flush

# ------------------------------------------------
# Install and activate external plugins and themes
# ------------------------------------------------

wp plugin install --activate contact-form-7 --version=5.7.7
wp theme install twentytwentythree --version=1.1

# ---------------------------------------------------
# Create skeleton content if it doesn't already exist
# ---------------------------------------------------

# "New Opera Company" page
if [[ !                                                                        \
  $(wp post list --post_type=page --name=new-opera-company --format=ids)       \
]]; then
  wp post create --post_type=page --post_name=new-opera-company                \
    --post_title="New Opera Company" --post_status=publish
fi

wp option set show_on_front page
wp option set page_on_front                                                    \
  $(wp post list --post_type=page --name=new-opera-company --format=ids)

# "Contact Us" page
if [[ !                                                                        \
  $(wp post list --post_type=page --name=contact-us --format=ids)              \
]]; then
  wp post create --post_type=page --post_name=contact-us                       \
    --post_title="Contact Us" --post_status=publish
fi

# Main Menu
if [[ ! $(wp menu list --format=ids) ]]; then
  wp menu create "Main Menu"
  wp menu item add-post main-menu                                              \
    $(wp post list --post_type=page --name=new-opera-company --format=ids)     \
    --attr-title=Home
  wp menu item add-post main-menu                                              \
    $(wp post list --post_type=page --name=contact-us --format=ids)
fi

# -----------------------------------
# Activate the site plugins and theme
# -----------------------------------

wp plugin activate newopera-productions
wp theme activate newopera-site

# ----------------------------------------------
# Upload the theme's images to the media library
# ----------------------------------------------

wp option update uploads_use_yearmonth_folders 0

for image in banner footer-logo header-logo
do

  for post in $(                                                               \
    wp post list --post_type=attachment --fields=ID,name --format=json |       \
    jq ".[] | select(.post_name | contains(\"$image\")) | .ID"                 \
  )
  do

    wp post delete $post --force

  done

  id=$(                                                                        \
    wp media import                                                            \
    wp-content/themes/newopera-site/assets/img/$image.webp --porcelain
  )

  if [ "$image" == 'header-logo' ]
  then

    wp option update site_logo $id

  fi

done

wp option update uploads_use_yearmonth_folders 1

# -------------------------------------
# Disable comments and pings by default
# -------------------------------------

wp option update default_pingback_flag ""
wp option update default_ping_status ""
wp option update default_comment_status ""

# ------------------------------------------------------
# Disable comments and pings on existing posts and pages
# ------------------------------------------------------

wp post list --format=ids                                                      \
  | xargs --no-run-if-empty wp post update --comment_status=closed
wp post list --format=ids                                                      \
  | xargs --no-run-if-empty wp post update --ping_status=closed
wp post list --post_type=page --format=ids                                     \
  | xargs --no-run-if-empty wp post update --ping_status=closed
