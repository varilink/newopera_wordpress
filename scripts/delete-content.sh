# ------------------------------------------------------------------------------
# wp-cli-scripts/delete-content.sh
# ------------------------------------------------------------------------------

set -e

# Posts
wp post list --format=ids                                                      \
  | xargs --no-run-if-empty wp post delete
# Pages
wp post list --format=ids --post_type=page                                     \
  | xargs --no-run-if-empty wp post delete
# Past Productions
wp post list --format=ids --post_type=past-production                          \
  | xargs --no-run-if-empty wp post delete --force
# Upcoming Productions
wp post list --format=ids --post_type=upcoming-production                      \
  | xargs --no-run-if-empty wp post delete --force
# Attachments
wp post list --format=ids --post_type=attachment                               \
  | xargs --no-run-if-empty wp post delete --force
# Contact Forms
wp post list --format=ids --post_type=wpcf7_contact_form                       \
  | xargs --no-run-if-empty wp post delete --force
# Block navigation menus
wp post list --format=ids --post_type=wp_navigation                            \
  | xargs --no-run-if-empty wp post delete --force
# Classi menus
wp menu delete "Main Menu"
