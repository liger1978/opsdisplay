$build_dependencies {
  'rpm-build' =>  {},
  'gcc'       =>  {},
  'ruby-devel' => {},
  'fpm'        => {
    provider => 'gem',
    require  => [Package['rpm-build', 'gcc', 'ruby-devel'],
  }
}
ensure_packages($build_dependencies)

exec{ 'build':
  cwd      => '/vagrant',
  command  => '/bin/make'
  path     => '/bin/:/usr/bin/',
  require  => Package['fpm'],
}