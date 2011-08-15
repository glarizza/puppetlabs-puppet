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
  $dashboard                = false,
  $puppet_conf              = $puppet::params::puppet_conf,
  $puppet_logdir            = $puppet::params::puppet_logdir,
  $puppet_vardir            = $puppet::params::puppet_vardir,
  $puppet_ssldir            = $puppet::params::puppet_ssldir,
  $puppet_defaults          = $puppet::params::puppet_defaults,
  $puppet_master_service    = $puppet::params::puppet_master_service,
  $puppet_agent_service     = $puppet::params::puppet_agent_service,
  $puppet_agent_name        = $puppet::params::puppet_agent_name,
  $puppet_server            = $puppet::params::puppet_server,
  $storeconfigs             = $puppet::params::storeconfigs,
  $storeconfigs_dbadapter   = $puppet::params::storeconfigs_dbadapter,
  $storeconfigs_dbuser      = $puppet::params::storeconfigs_dbuser,
  $storeconfigs_dbpassword  = $puppet::params::storeconfigs_dbpassword,
  $storeconfigs_dbserver    = $puppet::params::storeconfigs_dbserver,
  $storeconfigs_dbsocket    = $puppet::params::storeconfigs_dbsocket,
  $certname                 = $puppet::params::certname,
  $puppet_master_package    = $puppet::params::puppet_master_package,
  $package_provider         = undef,
  $modulepath               = $puppet::params::modulepath,
  $dashboard_version        = undef,
  $dashboard_site           = undef,
  $dashboard_user           = undef,
  $dashboard_password       = undef

) inherits puppet::params {

  $v_bool = [ '^true$', '^false$' ]
  $v_alphanum = '^[._0-9a-zA-Z:-]+$'
  $v_path = '^/'
  validate_re($version, $v_alphanum)
  validate_re("$master", $v_bool)
  validate_re("$agent", $v_bool)
  validate_re("$dashboard", $v_bool)
  validate_re("$storeconfigs", $v_bool)
  validate_re($puppet_conf, $v_path)
  validate_re($puppet_logdir, $v_path)
  validate_re($puppet_vardir, $v_path)
  validate_re($puppet_ssldir, $v_path)
  validate_re($puppet_defaults, $v_path)
  validate_re($puppet_master_service, $v_alphanum)
  validate_re($puppet_agent_service, $v_alphanum)
  validate_re($puppet_agent_name, $v_alphanum)
  validate_re($puppet_server, $v_alphanum)
  validate_re($storeconfigs_dbadapter,$v_alphanum)
  validate_re($storeconfigs_dbuser, $v_alphanum)
  validate_re($storeconfigs_dbpassword, $v_alphanum)
  validate_re($storeconfigs_dbsocket, $v_path)
  validate_re($storeconfigs_dbserver, $v_alphanum)
  validate_re($certname, $v_alphanum)
  validate_re($modulepath, $v_path)

  $version_real                 = $version
  $master_real                  = $master
  $agent_real                   = $agent
  $dashboard_real               = $dashboard
  $puppet_conf_real             = $puppet_conf
  $puppet_logdir_real           = $puppetlogdir
  $puppet_vardir_real           = $puppet_vardir
  $puppet_ssldir_real           = $puppet_ssldir
  $puppet_defaults_real         = $puppet_defaults
  $puppet_master_service_real   = $puppet_master_service
  $puppet_agent_service_real    = $puppet_agent_service
  $puppet_agent_name_real       = $puppet_agent_name
  $puppet_server_real           = $puppet_server
  $storeconfigs_dbadapter_real  = $storeconfigs_dbadapter
  $storeconfigs_dbuser_real     = $storeconfigs_dbuser
  $storeconfigs_dbpassword_real = $storeconfigs_dbpassword
  $storeconfigs_dbsocket_real   = $storeconfigs_dbsocket
  $storeconfigs_dbserver_real   = $storeconfigs_dbserver
  $storeconfigs_real            = $storeconfigs
  $certname_real                = $certname
  $puppet_master_package_real   = $puppet_master_package
  $modulepath_real              = $modulepath

  if $dashboard_real {

    class {'dashboard':
      dashboard_version         => $dashboard_version,
      dashboard_site            => $dashboard_site,
      dashboard_user            => $dashboard_user,
      dashboard_password        => $dashboard_password,
    }
  }

  if $master_real {
    class {'puppet::master':
      version                   => $version_real,
      modulepath                => $modulepath_real,
      storeconfigs              => $storeconfigs_real,
      storeconfigs_dbadapter    => $storeconfigs_dbadapter_real,
      storeconfigs_dbuser       => $storeconfigs_dbuser_real,
      storeconfigs_dbpassword   => $storeconfigs_dbpassword_real,
      storeconfigs_dbserver     => $storeconfigs_dbserver_real,
      storeconfigs_dbsocket     => $storeconfigs_dbsocket_real,
      certname                  => $certname_real,
      puppet_master_service     => $puppet_master_service_real,
      puppet_master_package     => $puppet_master_package_real,
      package_provider          => $package_provider,
    }
  }

  if $agent_real {
    class {'puppet::agent':
      version                   => $version_real,
      puppet_defaults           => $puppet_defaults_real, 
      puppet_agent_service      => $puppet_agent_service_real,
      puppet_agent_name         => $puppet_agent_name_real,
      puppet_server             => $puppet_server_real,
      puppet_conf               => $puppet_conf_real,
    }
  }

}

