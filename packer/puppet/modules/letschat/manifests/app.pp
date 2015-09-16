class letschat::app (
  $deploy_dir      = $letschat::params::lc_deploy_dir,
  $http_enabled    = $letschat::params::http_enabled,
  $lc_bind_address = $letschat::params::lc_bind_address,
  $http_port       = $letschat::params::http_port,
  $ssl_enabled     = $letschat::params::ssl_enabled,
  $ssl_port        = $letschat::params::ssl_port,
  $ssl_key         = $letschat::params::ssl_key,
  $ssl_cert        = $letschat::params::ssl_cert,
  $xmpp_enabled    = $letschat::params::xmpp_enabled,
  $xmpp_port       = $letschat::params::xmpp_port,
  $xmpp_domain     = $letschat::params::xmpp_domain,
  $dbuser          = $letschat::params::db_user,
  $dbpass          = $letschat::params::db_pass,
  $dbhost          = $letschat::params::db_host,
  $dbname          = $letschat::params::db_name,
  $dbport          = $letschat::params::db_port,
  $cookie          = $letschat::params::cookie,
  $authproviders   = $letschat::params::authproviders,
  $registration    = $letschat::params::registration,
) inherits letschat::params {

  $dependencies = ['g++', 'make', 'git', 'curl', 'vim', 'libkrb5-dev']

  class { 'nodejs':
    repo_url_suffix => 'node_0.12',
  }
  package { $dependencies:
    ensure => present,
    before => Class['nodejs'],
  }

  vcsrepo { $deploy_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/hashicorp/lets-chat.git',
    require  => Class['nodejs'],
  }

  package { 'dnsmasq':
    ensure  => present,
    require => Vcsrepo[$deploy_dir],
  }

  file { '/etc/dnsmasq.d/10-consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
    notify  => Service['dnsmasq'],
    require => Package['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure  => running,
    require => File['/etc/dnsmasq.d/10-consul'],
  }

  file { "${deploy_dir}/settings.yml":
    ensure  => present,
    content => template('letschat/settings.yml.erb'),
    require => Service['dnsmasq'],
  }

  nodejs::npm { 'install letschat':
    ensure          => present,
    package         => $deploy_dir,
    install_options => ['--user=root'],
    target          => $deploy_dir,
    require         => File["${deploy_dir}/settings.yml"],
  }

  file { '/etc/init.d/letschat':
    ensure  => present,
    content => template('letschat/letschat.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Nodejs::Npm['install letschat'],
  }

  service { 'letschat':
    ensure    => 'running',
    enable    => true,
    subscribe => File["${deploy_dir}/settings.yml"],
    require   => File['/etc/init.d/letschat'],
  }
}
