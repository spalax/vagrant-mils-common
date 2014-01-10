class puphpet::nginx(
  $fastcgi_pass = '127.0.0.1:9000',
  $webroot      = $puphpet::params::nginx_webroot_location,
  $aliases      = false
) inherits puphpet::params {

  $conf_file = $::osfamily ? {
    'debian' => '/etc/nginx/conf.d/default.conf',
    'redhat' => '/etc/nginx/conf.d/default.conf',
    default  => '/etc/nginx/conf.d/default.conf',
  }

  file { '/var/log/nginx':
    ensure  => directory,
    recurse => true,
  }

  file { ['/var/log/nginx/host.access.log', '/var/log/nginx/host.error.log']:
    ensure  => present,
    mode    => 0777,
    replace => 'no',
    require => File['/var/log/nginx']
  }

notify { 'IN NGINX.pp': 
  withpath => true,
    name     => "my aliases value is $aliases",
    }

  if $aliases == true {
     $template_string = "fastcgi_param SERVER_NAME \$http_host;"
  } else {
     $template_string = ""
  }

  file {"${conf_file} puphpet::nginx override":
    ensure  => present,
    path    => $conf_file,
    replace => 'yes',
    content => template('puphpet/nginx/default_conf.erb'),
    notify  => Service['nginx'],
  }
}
