# Install Docker

class profile::docker::install {
  $data_dir   = lookup('assets::docker::datasourcedir')
  $registries = lookup('docker::registry_auth::registries', { 'merge' => 'hash' })

  include docker

  # Configure all private registries
  create_resources('docker::registry', $registries)

  # Ensure the basic data directory exists
  file { $data_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
