$build_dependencies = {
  'rpm-build' =>  {},
  'gcc'       =>  {},
  'ruby-devel' => {},
  'fpm'        => {
    provider => 'gem',
    require  => [Package['rpm-build', 'gcc', 'ruby-devel']],
  }
}
create_resources(package, $build_dependencies)

exec{ 'build':
  cwd      => '/vagrant',
  command  => 'make',
  path     =>
    '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
  require  => Package['fpm'],
}