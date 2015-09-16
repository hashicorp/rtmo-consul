class letschat {
  class { 'letschat::db': } ->
  class { 'letschat::app': }
}
