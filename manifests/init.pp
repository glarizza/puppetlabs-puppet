# Class: puppet
#
# This class installs and configures Puppet Agent, Master, and Dashboard
#
# Parameters:
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
  $modulepath               = $puppet::params::modulepath,
  $dashboard_ensure         = undef,
  $dashboard_user           = undef,
  $dashboard_group          = undef,
  $dashboard_password       = undef,
  $dashboard_db             = undef,
  $dashboard_charset        = undef,
  $mysql_root_pw            = undef

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
      dashboard_ensure          => $dashboard_ensure,
      dashboard_user            => $dashboard_user,
      dashboard_group           => $dashboard_group,
      dashboard_password        => $dashboard_password,
      dashboard_db              => $dashboard_db,
      dashboard_charset         => $dashboard_charset,
      mysql_root_pw             => $mysql_root_pw,
    }
  }

  if $master_real {
    class {'puppet::master':
      version                 => $version_real,
      modulepath              => $modulepath_real,
      storeconfigs            => $storeconfigs_real,
      storeconfigs_dbadapter  => $storeconfigs_dbadapter_real,
      storeconfigs_dbuser     => $storeconfigs_dbuser_real,
      storeconfigs_dbpassword => $storeconfigs_dbpassword_real,
      storeconfigs_dbserver   => $storeconfigs_dbserver_real,
      storeconfigs_dbsocket   => $storeconfigs_dbsocket_real,
      certname                => $certname_real,
      puppet_master_service   => $puppet_master_service_real,
      puppet_master_package   => $puppet_master_package_real,
    }
  }

  if $agent_real {
    class {'puppet::agent':
      version              => $version_real,
      puppet_defaults      => $puppet_defaults_real,
      puppet_agent_service => $puppet_agent_service_real,
      puppet_agent_name    => $puppet_agent_name_real,
      puppet_server        => $puppet_server_real,
      puppet_conf          => $puppet_conf_real,
    }
  }

}

