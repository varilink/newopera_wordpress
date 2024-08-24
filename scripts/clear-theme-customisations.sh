# ------------------------------------------------------------------------------
# wp-cli-scripts/clear-theme-customisations.sh
# ------------------------------------------------------------------------------

set -e

wp post list --post_type=wp_global_styles --format=ids                         \
  | xargs --no-run-if-empty wp post delete --force

wp post list --post_type=wp_template --format=ids                              \
  | xargs --no-run-if-empty wp post delete --force

wp post list --post_type=wp_template_part --format=ids                         \
  | xargs --no-run-if-empty wp post delete --force
