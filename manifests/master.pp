# Class: puppet::master
#
# This class installs and configures a Puppet master
#
# Parameters:
# * modulepath
# * storeconfigs
# * dbadapter
# * dbuser
# * dbpassword
# * dbserver
# * dbsocket
# * certname
#
# Actions:
#
# Requires:
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
  $puppet_master_package,
  $puppet_master_service,
  $version

) {

  if $storeconfigs {
    
    class { 'puppet::storeconfigs':
      storeconfigs_dbadapter  => $storeconfigs_dbadapter,
      storeconfigs_dbuser     => $storeconfigs_dbuser,
      storeconfigs_dbpassword => $storeconfigs_dbpassword,
      storeconfigs_dbserver   => $storeconfigs_dbserver,
      storeconfigs_dbsocket   => $storeconfigs_dbsocket,
    }
  }

  package { $puppet_master_package:
    ensure => $version,
  }

  file { '/etc/puppet/namespaceauth.conf':
    owner  => root,
    group  => root,
    mode   => 644,
    source => 'puppet:///modules/puppet/namespaceauth.conf',
  }

  concat::fragment { 'puppet.conf-header':
    order   => '05',
    target  => "/etc/puppet/puppet.conf",
    content => template("puppet/puppet.conf-master.erb"),
    before  => Service[$puppet_master_service],
  }

  service { $puppet_master_service:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => File['/etc/puppet/puppet.conf'],
    #before    => Service['httpd'];
  }

}

