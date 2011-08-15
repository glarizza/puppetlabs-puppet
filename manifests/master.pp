# Class: puppet::master
#
# This class installs and configures a Puppet master
#
# Parameters:
#   [*modulepath*]            - The modulepath configuration value used in
#                               puppet.conf
#   [*confdir*]               - The confdir configuration value in puppet.conf
#   [*manifest*]              - The manifest configuration value in puppet.conf
#   [*storeconfigs*]          - Boolean determining whether storeconfigs is
#                               to be enabled.
#   [*storeconfigs_dbadapter*] - The database adapter to use with storeconfigs
#   [*storeconfigs_dbuser*]   - The database username used with storeconfigs
#   [*storeconfigs_dbpassword*] - The database password used with storeconfigs
#   [*storeconfigs_dbserver*]   - Fqdn of the storeconfigs database server
#   [*storeconfigs_dbsocket*]   - The path to the mysql socket file
#   [*install_mysql_pkgs*]      - Boolean determining whether mysql and related
#                                 devel packages should be installed.
#   [*certname*]              - The certname configuration value in puppet.conf
#   [*autosign*]              - The autosign configuration value in puppet.conf
#   [*dashboard_port*]          - The port on which puppet-dashboard should run
#   [*puppet_passenger*]      - Boolean value to determine whether puppet is
#                               to be run with Passenger
#   [*puppet_site*]           - The VirtualHost value used in the apache vhost
#                               configuration file when Passenger is enabled
#   [*puppet_docroot*]        - The DocumentRoot value used in the apache vhost
#                               configuration file when Passenger is enabled
#   [*puppet_passenger_port*] - The port on which puppet is listening when
#                               Passenger is enabled
#   [*puppet_master_package*]   - The name of the puppet master package
#   [*package_provider*]        - The provider used for package installation
#   [*version*]               - The value of the ensure parameter for the
#                               puppet master and agent packages
#
# Actions:
#
# Requires:
#
#  Class['concat']
#  Class['stdlib']
#  Class['concat::setup']
#  Class['mysql'] (conditionally)
#
# Sample Usage:
#
#  $modulepath = [
#    "/etc/puppet/modules/site",
#    "/etc/puppet/modules/dist",
#  ]
#
#  class { "puppet::master":
#    modulepath => inline_template("<%= modulepath.join(':') %>"),
#    dbadapter  => "mysql",
#    dbuser     => "puppet",
#    dbpassword => "password"
#    dbsocket   => "/var/run/mysqld/mysqld.sock",
#  }
#
class puppet::master (
  $modulepath,
  $storeconfigs,
  $storeconfigs_dbadapter,
  $storeconfigs_dbuser,
  $storeconfigs_dbpassword,
  $storeconfigs_dbserver,
  $storeconfigs_dbsocket,
  $certname,
  $autosign,
  $puppet_master_package,
  $package_provider = undef,
  $puppet_master_service,
  $version

) inherits puppet::params {

  if $package_provider == 'gem' {
    Concat::Fragment['puppet.conf-header']->Exec['puppet_master_start']
  } else {
    Concat::Fragment['puppet.conf-header']->Service[$puppet_master_service]
  }

  if $storeconfigs {
    class { 'puppet::storeconfigs':
      dbadapter  => $storeconfigs_dbadapter,
      dbuser     => $storeconfigs_dbuser,
      dbpassword => $storeconfigs_dbpassword,
      dbserver   => $storeconfigs_dbserver,
      dbsocket   => $storeconfigs_dbsocket,
    }
  }

  package { $puppet_master_package:
    ensure => $version,
    provider => $package_provider,
  }

  file { '/etc/puppet/namespaceauth.conf':
    owner  => root,
    group  => root,
    mode   => 644,
    source => 'puppet:///modules/puppet/namespaceauth.conf',
  }

  if ! defined(Concat[$pupet_conf]) {
    concat { $puppet_conf:
      mode    => '0644',
      require => Package[$puppet_master_package],
    }
  } else {
    Concat<| title == $puppet_conf |> {
      require => Package[$puppet_master_package]
    }
  }

  concat::fragment { 'puppet.conf-header':
    order   => '05',
    target  => "/etc/puppet/puppet.conf",
    content => template("puppet/puppet.conf-master.erb"),
  }

  if $package_provider == 'gem' {
    exec { 'puppet_master_start':
      command   => '/usr/bin/nohup puppet master &',
      refresh   => '/usr/bin/pkill puppet && /usr/bin/nohup puppet master &',
      unless    => "/bin/ps -ef | grep -v grep | /bin/grep 'puppet master'",
      require   => File['/etc/puppet/puppet.conf'],
      subscribe => Package[$puppet_master_package],
    }
  } else {
    service { $puppet_master_service:
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => File['/etc/puppet/puppet.conf'],
      subscribe => Package[$puppet_master_package],
      #before    => Service['httpd'];
    }
  }
}

