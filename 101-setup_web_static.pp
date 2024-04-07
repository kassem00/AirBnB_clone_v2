#!/usr/bin/puppet apply
# web_static_setup.pp
# Puppet manifest to set up web servers for the deployment of web_static, including Nginx configuration

# Ensure the Nginx package is installed
package { 'nginx':
  ensure => installed,
  before => File['/data/web_static/releases/test/index.html', '/etc/nginx/nginx.conf', '/etc/nginx/sites-available/default', '/var/www/index.html', '/usr/share/nginx/html/index.html'],
}

# Update and upgrade the system packages
# Note: Puppet does not directly manage apt-get update/upgrade. You should manage updates outside of Puppet or use a module that handles it.

# Create required directories and files
file { '/data/web_static/releases/test':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

file { '/data/web_static/shared':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

file { '/data/web_static/releases/test/index.html':
  ensure  => 'file',
  content => 'test 1234',
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test',
}

file { '/etc/nginx/nginx.conf':
  ensure  => 'file',
  content => template('path/to/nginx.conf.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'file',
  content => template('path/to/default.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

file { '/var/www/index.html':
  ensure  => 'file',
  content => 'Hello World!',
  require => Package['nginx'],
}

file { '/usr/share/nginx/html/index.html':
  ensure  => 'file',
  content => 'Hello World!',
  require => Package['nginx'],
}

# Add custom location block to Nginx site configuration
# Puppet does not support inserting lines at a specific location directly.
# You should manage the entire file content or use augeas resource type or an exec resource with sed as a workaround.

# Ensure Nginx service is running
service { 'nginx':
  ensure => 'running',
  enable => true,
}

