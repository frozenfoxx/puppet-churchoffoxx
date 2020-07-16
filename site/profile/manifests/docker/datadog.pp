# Deploy a DataDog Agent container

class profile::docker::datadog {
  $datadog_api_key = lookup('assets::datadog::apikey')

  docker::run { 'datadog':
    image           => 'datadog/agent:latest',
    env             => [
      "DD_API_KEY=${datadog_api_key}"
    ],
    volumes         => [
      '/var/run/docker.sock:/var/run/docker.sock:ro',
      '/proc/:/host/proc/:ro',
      '/sys/fs/cgroup/:/host/sys/fs/cgroup:ro'
    ],
    restart_service => true
  }
}
