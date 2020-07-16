# Deploy a Logz.io collector container

class profile::docker::logzio {
  $logzio_token = lookup('assets::logzio::token')
  $logzio_url   = lookup('assets::logzio::url')

  docker::run { 'logzio-collector':
    image           => 'logzio/docker-collector-logs:latest',
    env             => [
      "LOGZIO_TOKEN=${logzio_token}",
      "LOGZIO_URL=${logzio_url}"
    ],
    volumes         => [
      '/var/run/docker.sock:/var/run/docker.sock:ro',
      '/var/lib/docker/containers:/var/lib/docker/containers'
    ],
    restart_service => true
  }
}
