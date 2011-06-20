# Class: puppet::params
#
# This class installs and configures parameters for Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::params {

  $puppet_server                    = 'baal.puppetlabs.com'
  $puppet_storeconfigs_password     = 'password'
  $modulepath                       = "/etc/puppet/modules"
  $storeconfigs                     = 'false'
  $storeconfigs_dbadapter           = 'sqlite3'
  $storeconfigs_dbuser              = 'puppet'
  $storeconfigs_dbpassword          = 'password'
  $storeconfigs_dbserver            = 'localhost'
  $storeconfigs_dbsocket            = '/var/run/mysqld/mysqld.sock'
  $certname                         = $fqdn

 case $operatingsystem {
    'centos', 'redhat', 'fedora': {
      $puppet_master_package        = 'puppet-server'
      $puppet_master_service        = 'puppetmaster'
      $puppet_agent_service         = 'puppet'
      $puppet_agent_name            = 'puppet'
      $puppet_defaults              = '/etc/sysconfig/puppet'
      $puppet_dashboard_report      = ''
      $puppet_storeconfigs_packages = 'mysql-devel'
      $puppet_conf                  = '/etc/puppet/puppet.conf'
      $puppet_logdir                = '/var/log/puppet'
      $puppet_vardir                = '/var/lib/puppet'
      $puppet_ssldir                = '/var/lib/puppet/ssl'
    }
    'ubuntu', 'debian': {
      $puppet_master_package        = 'puppetmaster'
      $puppet_master_service        = 'puppetmaster'
      $puppet_agent_service         = 'puppet'
      $puppet_agent_name            = 'puppet'
      $puppet_defaults              = '/etc/default/puppet'
      $puppet_dashboard_report      = '/usr/lib/ruby/1.8/puppet/reports/puppet_dashboard.rb'
      $puppet_storeconfigs_packages = 'libmysql-ruby'
      $puppet_conf                  = '/etc/puppet/puppet.conf'
      $puppet_logdir                = '/var/log/puppet'
      $puppet_vardir                = '/var/lib/puppet'
      $puppet_ssldir                = '/var/lib/puppet/ssl'
    }
    'freebsd': {
      $puppet_agent_service         = 'puppet'
      $puppet_agent_name            = 'puppet'
      $puppet_conf                  = '/usr/local/etc/puppet/puppet.conf'
      $puppet_logdir                = '/var/log/puppet'
      $puppet_vardir                = '/var/puppet'
      $puppet_ssldir                = '/var/puppet/ssl'
    }
    'darwin': {
      $puppet_agent_service         = 'com.puppetlabs.puppet'
      $puppet_agent_name            = 'puppet'
      $puppet_conf                  = '/etc/puppet/puppet.conf'
      $puppet_logdir                = '/var/log/puppet'
      $puppet_vardir                = '/var/lib/puppet'
      $puppet_ssldir                = '/etc/puppet/ssl'
    }
 }

}
