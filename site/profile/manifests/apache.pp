class profile::apache {
  # Data is stored separately in Hiera
  $sites = lookup('websites', {merge => hash})

  # Manage Apache HTTPD
  class { 'apache': }
  include apache::mod::php
  include apache::mod::fastcgi
  include apache::mod::prefork
  include apache::mod::rewrite
  include apache::mod::ssl
  create_resources('apache::vhost', $sites)
  apache::vhost { 'www.churchoffoxx.net':
    docroot          => '/var/www/html/churchoffoxx.net',
    port             => '80',
    rewrites         => [
      {
        comment      => 'Force HTTPS',
        rewrite_cond => ['%{HTTPS} off'],
        rewrite_rule => ['(.*) https://%{HTTP_HOST}%{REQUEST_URI}'],
      },
    ],
  }
}
