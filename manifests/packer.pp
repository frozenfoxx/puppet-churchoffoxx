node default {
}

node /^mgmt-jenkins-vsphere.*$/ {
  include role::jenkins::vsphere::packer
}
