# Install open-vm-tools

class profile::openvmtools {
  package { 'open-vm-tools': }
  package { 'perl': }
}
