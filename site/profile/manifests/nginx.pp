class profile::nginx {
  # Data is stored separately in Hiera
  $sites = lookup('websites', {merge => hash})

  # Manage Nginx
  class { 'nginx': }
  create_resources('nginx::resource::server', $sites)
}
