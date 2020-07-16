# Installs and sets up Archive
class profile::archive {

  # Set variables based on OS family
  case $facts['os']['family'] {
    'Debian': {
      $packages = [ 'curl', 'unzip' ]
    }
    default: {
      $packages = [ 'curl', 'unzip' ]
    }
  }

  create_resources(package, $packages)
  -> class { 'archive': }
}
