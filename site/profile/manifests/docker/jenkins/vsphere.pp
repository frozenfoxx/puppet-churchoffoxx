# Deploy a Jenkins vSphere container

class profile::docker::jenkins::vsphere {
  $data_dir           = lookup('assets::docker::datasourcedir')
  $registry           = lookup('assets::docker::registry')
  $casc_configs       = lookup('assets::jenkins::casc_configs')
  $config             = lookup('assets::jenkins::config')
  $gid                = lookup('assets::jenkins::gid')
  $ip                 = $facts['networking']['ip']
  $fqdn               = $facts['networking']['fqdn']
  $hudson_util_secret = base64('decode', lookup('assets::jenkins::hudson_util_secret'))
  $java_opts          = lookup('assets::jenkins::java_opts')
  $jenkins_dirs       = [
    "${data_dir}/jenkins",
    "${data_dir}/jenkins/casc_configs",
    "${data_dir}/jenkins/jenkins_home",
    "${data_dir}/jenkins/jenkins_home/secrets",
  ]
  $jenkins_home       = lookup('assets::jenkins::jenkins_home')
  $masterkey          = lookup('assets::jenkins::masterkey')
  $nodemonitors       = lookup('assets::jenkins::nodemonitors')
  $secretkey          = lookup('assets::jenkins::secretkey')
  $uid                = lookup('assets::jenkins::uid')

  docker::run { 'jenkins-vsphere':
    image           => "${registry}/jenkins-vsphere",
    env             => [
      "CASC_JENKINS_CONFIG=${casc_configs}/jenkins.yml",
      "JAVA_OPTS=${java_opts}",
      "JENKINS_HOME=${jenkins_home}"
    ],
    ports           => ['8080:8080','50000:50000'],
    volumes         => [
      "${data_dir}/jenkins/casc_configs/:${casc_configs}",
      "${data_dir}/jenkins/jenkins_home/:${jenkins_home}",
    ],
    require         => [
      File['jenkins.yml'],
      File['nodeMonitors.xml'],
      File['secret.key'],
      File['master.key'],
      File['hudson.util.Secret']
    ],
    restart_service => true
  }

  # Ensure the data directory tree exists
  file { $jenkins_dirs:
    ensure => directory,
    owner  => $uid,
    group  => $gid,
    mode   => '0750'
  }

  # Roll out a jenkins.yml file if none exists
  file { 'jenkins.yml':
    ensure  => file,
    path    => "${data_dir}/jenkins/casc_configs/jenkins.yml",
    owner   => $uid,
    group   => $gid,
    mode    => '0655',
    replace => no,
    content => $config,
    require => File["${data_dir}/jenkins/casc_configs"]
  }

  # Roll out a nodeMonitors.xml if none exists
  file { 'nodeMonitors.xml':
    ensure  => file,
    path    => "${data_dir}/jenkins/jenkins_home/nodeMonitors.xml",
    owner   => $uid,
    group   => $gid,
    mode    => '0644',
    replace => no,
    content => $nodemonitors,
    require => File["${data_dir}/jenkins/jenkins_home"]
  }

  # Roll out a secret.key if none exists
  file { 'secret.key':
    ensure  => file,
    path    => "${data_dir}/jenkins/jenkins_home/secret.key",
    owner   => $uid,
    group   => $gid,
    mode    => '0655',
    replace => no,
    content => $secretkey,
    require => File["${data_dir}/jenkins/jenkins_home"]
  }

  # Roll out a master.key if none exists
  file { 'master.key':
    ensure  => file,
    path    => "${data_dir}/jenkins/jenkins_home/secrets/master.key",
    owner   => $uid,
    group   => $gid,
    mode    => '0655',
    replace => no,
    content => $masterkey,
    require => File["${data_dir}/jenkins/jenkins_home"]
  }

  # Roll out a hudson.util.Secret if none exists
  file { 'hudson.util.Secret':
    ensure  => file,
    path    => "${data_dir}/jenkins/jenkins_home/secrets/hudson.util.Secret",
    owner   => $uid,
    group   => $gid,
    mode    => '0655',
    replace => no,
    content => $hudson_util_secret,
    require => File["${data_dir}/jenkins/jenkins_home"]
  }
}
