class { 'letschat::db':
  user          => 'lcadmin',
  pass          => 'unsafepassword',
  bind_ip       => '0.0.0.0',
  database_name => 'letschat',
  database_port => '27017',
}
