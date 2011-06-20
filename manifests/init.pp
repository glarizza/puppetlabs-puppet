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

  if $dashboard {

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

  if $master {
    class {'puppet::master':
      version                 => $version,
      modulepath              => $modulepath,
      storeconfigs            => $storeconfigs,
      storeconfigs_dbadapter  => $storeconfigs_dbadapter,
      storeconfigs_dbuser     => $storeconfigs_dbuser,
      storeconfigs_dbpassword => $storeconfigs_dbpassword,
      storeconfigs_dbserver   => $storeconfigs_dbserver,
      storeconfigs_dbsocket   => $storeconfigs_dbsocket,
      certname                => $certname,
      puppet_master_service   => $puppet_master_service,
      puppet_master_package   => $puppet_master_package,
    }
  }

  if $agent {
    class {'puppet::agent':
      version              => $version,
      puppet_defaults      => $puppet_defaults,
      puppet_agent_service => $puppet_agent_service,
      puppet_agent_name    => $puppet_agent_name,
      puppet_server        => $puppet_server,
      puppet_conf          => $puppet_conf,
    }
  }

}

