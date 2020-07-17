# Run a Redis container

class profile::docker::redis {
  docker::run { 'redis':
    image           => 'redis',
    ports           => ['6379:6379'],
    restart_service => true,
    volumes         => ['redis-volume:/data']
  }

  docker_volume { 'redis-volume':
    ensure => present,
    driver => 'local'
  }
}
