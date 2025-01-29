# ------------------------------------------------------------------------------
# wp-cli-scripts/init.sh
# ------------------------------------------------------------------------------

set -e

# -------------------------
# Blog name and description
# -------------------------

wp option set blogname 'New Opera Company'

wp option set blogdescription                                                  \
'New Opera Company, Derby was founded in 1957 to sing grand opera.'

# -------
# Plugins
# -------

# Installed and activated in all environments
wp plugin install --activate 3d-flipbook-dflip-lite --version=2.2.56
wp plugin install --activate contact-form-7 --version=5.9.8
wp plugin install --activate filebird --version=6.3.2
wp plugin install --activate nextgen-gallery --version=3.59.4

# Installed in all environments, not activated in all environments
wp plugin install restricted-site-access --version=7.5.1
wp plugin install wp-mail-smtp --version=4.1.1

# Activate site plugin(s)
wp plugin activate newopera-productions

# Delete redundant plugins
wp plugin is-installed akismet
if [ $? -eq 0 ]; then wp plugin delete akismet; fi
wp plugin is-installed hello
if [ $? -eq 0 ]; then wp plugin delete hello; fi

# ------
# Themes
# ------

# Install and activate parent theme
wp theme install twentytwentythree --version=1.6 --activate

# Activate child theme
wp theme activate newopera-site

# Delete redundant themes
wp theme delete twentytwentyone
wp theme delete twentytwentytwo
wp theme delete twentytwentyfour

# -------------------
# Permalink structure
# -------------------

wp rewrite structure '/%postname%/'
wp rewrite flush

# -------------------------------
# Skeleton pages (if no existing)
# -------------------------------

# "New Opera Company" (Home) page
if [[ !                                                                        \
  $(wp post list --post_type=page --name=new-opera-company --format=ids)       \
]]; then
  wp post create --post_type=page --post_name=new-opera-company                \
    --post_title="New Opera Company" --post_status=publish
fi

wp option set show_on_front page
wp option set page_on_front                                                    \
  $(wp post list --post_type=page --name=new-opera-company --format=ids)

# "Past Productions" page
if [[ !                                                                        \
  $(wp post list --post_type=page --name=past-productions --format=ids)        \
]]; then
  wp post create --post_type=page --post_name=past-productions                 \
    --post_title="Past Productions" --post_status=publish
fi

# "Gallery" page
if [[ !                                                                        \
  $(wp post list --post_type=page --name=gallery --format=ids)                 \
]]; then
  wp post create --post_type=page --post_name=gallery                          \
    --post_title="Gallery" --post_status=publish
fi

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
    --title=Home
  wp menu item add-post main-menu                                              \
    $(wp post list --post_type=page --name=past-productions --format=ids)
  wp menu item add-post main-menu                                              \
    $(wp post list --post_type=page --name=gallery --format=ids)
  wp menu item add-post main-menu                                              \
    $(wp post list --post_type=page --name=contact-us --format=ids)
fi

# ----------
# The images
# ----------

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

# --------------------------
# Disable comments and pings
# --------------------------

# By default
wp option update default_pingback_flag ""
wp option update default_ping_status ""
wp option update default_comment_status ""

# On existing posts and pages
wp post list --format=ids                                                      \
  | xargs --no-run-if-empty wp post update --comment_status=closed
wp post list --format=ids                                                      \
  | xargs --no-run-if-empty wp post update --ping_status=closed
wp post list --post_type=page --format=ids                                     \
  | xargs --no-run-if-empty wp post update --ping_status=closed
