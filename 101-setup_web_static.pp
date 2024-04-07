# nginx_setup.pp
# Puppet manifest to set up Nginx and configure web static directories and files

# Ensure Nginx is installed, updating and upgrading packages as necessary
class { 'nginx':
  manage_repo    => true,
  package_ensure => installed,
}

# Create necessary directories for web_static
file { ['/data/web_static/releases/test', '/data/web_static/shared', '/var/www/']:
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Create test index.html in the test directory
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => 'test 1234',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => File['/data/web_static/releases/test'],
}

# Create symbolic link to current web_static version
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test',
  require => File['/data/web_static/releases/test/index.html'],
}

# Set owner for /data directory recursively
file { '/data':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Custom Nginx configuration
file { '/etc/nginx/nginx.conf':
  ensure  => file,
  content => template('modulename/nginx.conf.erb'),
  require => Class['nginx'],
  notify  => Service['nginx'],
}

file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => template('modulename/default-site.erb'),
  require => Class['nginx'],
  notify  => Service['nginx'],
}

# Insert custom location for static content
exec { 'insert-static-location':
  command => "sed -i '8i\\tlocation /hbnb_static/ {\\n\\t\\talias /data/web_static/current/;\\n\\t}\\n' /etc/nginx/sites-available/default",
  path    => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
  onlyif  => "test ! $(grep -q 'hbnb_static' /etc/nginx/sites-available/default)",
  require => File['/etc/nginx/sites-available/default'],
  notify  => Service['nginx'],
}

# Ensure nginx service is running and enabled
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/nginx/nginx.conf', '/etc/nginx/sites-available/default'],
}

# Additional configurations and files as required
file { '/var/www/index.html':
  ensure  => file,
  content => 'Hello World!',
  require => File['/var/www/'],
}

file { '/usr/share/nginx/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  require => Class['nginx'],
  notify  => Service['nginx'],
}
