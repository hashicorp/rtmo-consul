class letschat::db (
  $user           = $letschat::params::db_user,
  $pass           = $letschat::params::db_pass,
  $bind_ip        = $letschat::params::mongo_bind_address,
  $database_name  = $letschat::params::db_name,
  $database_port  = $letschat::params::db_port,
) inherits letschat::params {

  class { '::mongodb::globals':
    manage_package_repo => true,
    bind_ip             => $bind_ip,
  }->

  class { '::mongodb::server':
    port    => $database_port,
    bind_ip => $bind_ip,
  } ->

  class { '::mongodb::client': }
  ->
  mongodb::db { $database_name:
    user     => $user,
    password => $pass,
  }
}
