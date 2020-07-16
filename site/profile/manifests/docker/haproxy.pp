# Deploy a haproxy container

class profile::docker::haproxy {
  $data_dir  = lookup('assets::docker::datasourcedir')
  $fqdn      = $facts['networking']['fqdn']
  $ip        = $facts['networking']['ip']
  $listeners = lookup('assets::haproxy::listeners', { 'merge' => 'hash' })
  $registry  = lookup('assets::docker::registry')

  docker::run { 'haproxy':
    image            => "${registry}/haproxy",
    env              => [
      "FQDN=${fqdn}"
    ],
    net              => ['host'],
    volumes          => ["${data_dir}/haproxy/:/data"],
    command          => '-f /data',
    extra_parameters => [ '--network host' ],
    require          => File["${data_dir}/haproxy"],
    restart_service  => true
  }

  # Ensure the data directory exists
  file { "${data_dir}/haproxy":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750'
  }

  # Roll out an haproxy.cfg template if none exists
  file { 'haproxy.cfg':
    ensure  => file,
    path    => "${data_dir}/haproxy/haproxy.cfg",
    owner   => 'root',
    group   => 'root',
    mode    => '0655',
    replace => no,
    content => template('assets/haproxy.cfg.erb'),
    require => File["${data_dir}/haproxy"]
  }
}
