# web_static_setup.pp
# Puppet manifest to set up web servers for the deployment of web_static

# Ensure the Nginx package is installed
package { 'nginx':
  ensure => installed,
}

# Ensure the system is updated and upgraded
# Note: Puppet doesn't have a built-in resource for apt-get update/upgrade,
# so we manage it with exec resource for demonstration purposes. This is not ideal for production.
exec { 'apt-update':
  command => '/usr/bin/apt-get update',
  path    => ['/usr/bin', '/usr/sbin'],
}

exec { 'apt-upgrade':
  command => '/usr/bin/apt-get upgrade -y',
  path    => ['/usr/bin', '/usr/sbin'],
  require => Exec['apt-update'],
}

# Create required directories
file { '/data/web_static/releases/test':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  require => Package['nginx'],
}

file { '/data/web_static/shared':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
  require => Package['nginx'],
}

# Create a test HTML file
file { '/data/web_static/releases/test/index.html':
  ensure  => 'file',
  content => 'This is a test',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
  require => File['/data/web_static/releases/test'],
}

# Create a symbolic link
file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test',
  require => File['/data/web_static/releases/test/index.html'],
}

# Configure Nginx to serve the static files
exec { 'nginx-config':
  command => "sed -i '38i\\tlocation /hbnb_static/ {\\n\\t\\talias /data/web_static/current/;\\n\\t}\\n' /etc/nginx/sites-available/default",
  path    => ['/bin', '/usr/bin', '/usr/sbin'],
  require => File['/data/web_static/current'],
  notify  => Service['nginx'],
}

# Ensure Nginx service is running
service { 'nginx':
  ensure => 'running',
  enable => true,
  require => Exec['nginx-config'],
}
