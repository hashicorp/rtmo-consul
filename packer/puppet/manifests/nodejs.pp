class { 'letschat::app':
  dbuser => 'lcadmin',
  dbpass => 'somepass',
  dbname => 'letschat',
  dbhost => 'database.service.consul',
}
