$version = '1.3.0'
$url = 'http://www.mattermost.org/'
$desc = 'An alternative to proprietary SaaS messaging.'
$vendor = 'Mattermost'
$license = 'MIT'
$arch = 'x86_64'
$packager = 'grainger@gmail.com'
$release_number = '1'
$user = 'mattermost'
$group = 'mattermost'
$pkg_uid = '1500'
$pkg_gid = '1500'
$symlink = '/opt/mattermost'
$dir = "/opt/mattermost-${version}"
$rvm_ruby = '1.9.3-p551'

case $::operatingsystem {
  'CentOS': { $packages     = ['rpm-build']
              $pkg_target   = 'rpm'
              $release_join = '.' }
  default:  { $packages     = []
              $pkg_target   = 'deb'
              $release_join = '' }
}
$service_file = $::hostname ? {
  /el6|squeeze|wheezy/ => '/etc/init.d/mattermost',
  /precise|trusty/     => '/etc/init/mattermost.conf',
  /el7|jessie|vivid/   => '/lib/systemd/system/mattermost.service',
}
$bld_release = "${release_number}${release_join}${::hostname}"

ensure_packages($packages)

class { '::rvm': }
rvm_system_ruby {"ruby-${rvm_ruby}": default_use => true} ->
rvm_gemset {"ruby-${rvm_ruby}@mattermost":
              ensure => present } ->
rvm_gem {"ruby-${rvm_ruby}@mattermost/fpm":}

class{ 'mattermost':
  version        => $version,
  manage_service => false,
  dir            => $dir,
  symlink        => $symlink,
}

file{ '/tmp/post_script.sh':
  content => template("${::templatedir}/post_script.sh.erb"),
  mode    => '0755',
}

exec{ 'build':
  cwd      => '/vagrant',
  command  => template("${::templatedir}/fpm.erb"),
  path     => '/bin/:/usr/bin/',
  require  => [ Rvm_gem["ruby-${rvm_ruby}@mattermost/fpm"],Package[$packages],
                Class['mattermost'],File['/tmp/post_script.sh'] ],
}