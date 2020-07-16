node default {
}

node /^mgmt-\w+-jenkins-vsphere-\d+.*$/ {
  include role::jenkins::vsphere::live
}
