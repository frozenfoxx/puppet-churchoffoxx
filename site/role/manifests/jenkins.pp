# Deploy a live Jenkins GCE host

class role::builder::gce::live {
  include profile::base
  include profile::docker::jenkins::gce
  include profile::fail2ban
  include profile::hosts
  include profile::htop
  include profile::unattendedupgrades
}

# Deploy a live Jenkins vSphere host

class role::jenkins::vsphere::live {
  include profile::base
  include profile::docker::jenkins::vsphere
  include profile::fail2ban
  include profile::hosts
  include profile::htop
  include profile::unattendedupgrades
}

# Prepare a Jenkins vSphere host in Packer

class role::jenkins::vsphere::packer {
  include profile::base
  include profile::docker::install
  include profile::fail2ban
  include profile::hosts
  include profile::htop
  include profile::unattendedupgrades
}
