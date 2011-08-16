# Class: puppet
#
# This class installs and configures Puppet Agent, Master, and Dashboard
#
# Parameters:
#
#   [*version*]               - The value of the ensure parameter for the
#                               puppet master and agent packages
#   [*master*]                - Boolean determining whether the the puppet
#                               master service should be setup
#   [*agent*]                 - Boolean determining whether the puppet agent
#                               should be setup
#   [*confdir*]               - The confdir configuration value in puppet.conf
#   [*manifest*]              - The manifest configuration value in puppet.conf
#   [*certname*]              - The certname configuration value in puppet.conf
#   [*autosign*]              - The autosign configuration value in puppet.conf
#   [*puppet_server*]         - The server configuration value in puppet.conf
#   [*modulepath*]            - The modulepath configuration value used in
#                               puppet.conf
#   [*puppet_conf*]           - The path to the puppet.conf file
#   [*puppet_logdir*]         - The path to the puppet log
#   [*puppet_vardir*]         - The path to the puppet vardir
#   [*puppet_defaults*]       - The path to your distro's puppet defaults file
#   [*puppet_master_service*] - The name of the puppet master service
#   [*puppet_agent_service*]  - The name of the puppet agent service
#   [*puppet_passenger*]      - Boolean value to determine whether puppet is
#                               to be run with Passenger
#   [*puppet_site*]           - The VirtualHost value used in the apache vhost
#                               configuration file when Passenger is enabled
#   [*puppet_passenger_port*] - The port on which puppet is listening when
#                               Passenger is enabled
#   [*puppet_docroot*]        - The DocumentRoot value used in the apache vhost
#                               configuration file when Passenger is enabled
#   [*storeconfigs*]          - Boolean determining whether storeconfigs is
#                               to be enabled.
#   [*storeconfigs_dbadapter*] - The database adapter to use with storeconfigs
#   [*storeconfigs_dbuser*]   - The database username used with storeconfigs
#   [*storeconfigs_dbpassword*] - The database password used with storeconfigs
#   [*storeconfigs_dbserver*]   - Fqdn of the storeconfigs database server
#   [*storeconfigs_dbsocket*]   - The path to the mysql socket file
#   [*install_mysql_pkgs*]      - Boolean determining whether mysql and related
#                                 devel packages should be installed.
#   [*puppet_master_package*]   - The name of the puppet master package
#   [*package_provider*]        - The provider used for package installation
#   [*user_id*]                 - The UID of the puppet user
#   [*group_id*]                - The GID of the puppet group
#   [*dashboard*]               - Boolean determining whether the puppet
#                                 dashboard is to be enabled
#   [*dashboard_ensure*]        - The value of the ensure parameter for the
#                                 puppet dashboard package
#   [*dashboard_user*]          - Name of the puppet-dashboard database and
#                                 system user
#   [*dashboard_group*]         - Name of the puppet-dashboard group
#   [*dashbaord_password*]      - Password for the puppet-dashboard database use
#   [*dashboard_db*]            - The puppet-dashboard database name
#   [*dashboard_charset*]       - Character set for the puppet-dashboard database
#   [*dashboard_site*]          - The ServerName setting for Apache
#   [*dashboard_port*]          - The port on which puppet-dashboard should run
#   [*dashboard_passenger*]     - Boolean to determine whether Dashboard is to be
#                                 used with Passenger
#   [*dashboard_mysql_provider*] - The package provider to use when installing
#                                  the ruby-mysql package
#   [*dashboard_mysql_pkg*]     - The package name used for installing the
#                                 ruby-mysql package
#
# Actions:
#
# Requires:
# 
#  Class['dashboard']
#  Class['mysql'] <--Storeconfigs
#  Class['ruby']
#  Class['concat']
#  Class['stdlib']
#  Class['concat::setup']
#  Class['activerecord']
#
# Sample Usage:
#
class puppet (
  $version                  = 'present',
  $master                   = false,
  $agent                    = true,
  $confdir                  = $puppet::params::confdir,
  $manifest                 = $puppet::params::manifest,
  $modulepath               = $puppet::params::modulepath,
  $puppet_conf              = $puppet::params::puppet_conf,
  $puppet_logdir            = $puppet::params::puppet_logdir,
  $puppet_vardir            = $puppet::params::puppet_vardir,
  $puppet_ssldir            = $puppet::params::puppet_ssldir,
  $puppet_defaults          = $puppet::params::puppet_defaults,
  $puppet_master_service    = $puppet::params::puppet_master_service,
  $puppet_agent_service     = $puppet::params::puppet_agent_service,
  $puppet_server            = $puppet::params::puppet_server,
  $puppet_passenger         = false,
  $puppet_site              = $puppet::params::puppet_site,
  $puppet_passenger_port    = $puppet::params::puppet_passenger_port,
  $puppet_docroot           = $puppet::params::puppet_docroot,
  $storeconfigs             = false,
  $storeconfigs_dbadapter   = $puppet::params::storeconfigs_dbadapter,
  $storeconfigs_dbuser      = $puppet::params::storeconfigs_dbuser,
  $storeconfigs_dbpassword  = $puppet::params::storeconfigs_dbpassword,
  $storeconfigs_dbserver    = $puppet::params::storeconfigs_dbserver,
  $storeconfigs_dbsocket    = $puppet::params::storeconfigs_dbsocket,
  $certname                 = $puppet::params::certname,
  $install_mysql_pkgs       = false,
  $autosign                 = false,
  $puppet_master_package    = $puppet::params::puppet_master_package,
  $package_provider         = undef,
  $user_id                  = undef,
  $group_id                 = undef,
  $dashboard                = false,
  $dashboard_ensure         = undef,
  $dashboard_user           = undef,
  $dashboard_group          = undef,
  $dashboard_password       = undef,
  $dashboard_db             = undef,
  $dashboard_charset        = undef,
  $dashboard_site           = undef,
  $dashboard_port           = undef,
  $dashboard_passenger      = undef,
  $dashboard_mysql_provider = undef,
  $dashboard_mysql_pkg      = undef

) inherits puppet::params {

  if $dashboard {
    class {'dashboard':
      dashboard_ensure       => $dashboard_version,
      dashboard_group        => $dashboard_group,
      dashboard_db           => $dashboard_db,
      dashboard_charset      => $dashboard_charset,
      dashboard_site         => $dashboard_site,
      dashboard_port         => $dashboard_port,
      passenger              => $dashboard_passenger,
      mysql_package_provider => $dashboard_mysql_provider,
      ruby_mysql_package     => $dashboard_mysql_pkg,
      dashboard_user         => $dashboard_user,
      dashboard_password     => $dashboard_password,
    }
  }

  if $master {
    class {'puppet::master':
      version                   => $version,
      confdir                   => $confdir,
      puppet_passenger          => $puppet_passenger,
      puppet_site               => $puppet_site,
      puppet_passenger_port     => $puppet_passenger_port,
      puppet_docroot            => $puppet_docroot,
      puppet_vardir             => $puppet_vardir,
      modulepath                => $modulepath,
      storeconfigs              => $storeconfigs,
      storeconfigs_dbadapter    => $storeconfigs_dbadapter,
      storeconfigs_dbuser       => $storeconfigs_dbuser,
      storeconfigs_dbpassword   => $storeconfigs_dbpassword,
      storeconfigs_dbserver     => $storeconfigs_dbserver,
      storeconfigs_dbsocket     => $storeconfigs_dbsocket,
      install_mysql_pkgs        => $install_mysql_pkgs,
      certname                  => $certname,
      autosign                  => $autosign,
      manifest                  => $manifest,
      puppet_master_service     => $puppet_master_service,
      puppet_master_package     => $puppet_master_package,
      package_provider          => $package_provider,
      dashboard_port            => $dashboard_port,
    }
  }

  if $agent {
    class {'puppet::agent':
      version                   => $version,
      puppet_defaults           => $puppet_defaults,
      puppet_agent_service      => $puppet_agent_service,
      puppet_server             => $puppet_server,
      puppet_conf               => $puppet_conf,
      puppet_agent_name         => $puppet_agent_name,
      package_provider          => $package_provider,
    }
  }

  user { 'puppet':
    ensure => present,
    uid    => $user_id,
    gid    => 'puppet',
  }

  group { 'puppet':
    ensure => present,
    gid    => $group_id,
  }

  file { '/etc/puppet':
    ensure       => directory,
    group        => 'puppet',
    owner        => 'puppet',
    recurse      => true,
    recurselimit => '1',
  }

}

