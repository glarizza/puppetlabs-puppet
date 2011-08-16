# Class: puppet::storedconfiguration
#
# This class installs and configures Puppet's stored configuration capability
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppet::storeconfigs (
    $dbadapter,
    $dbuser,
    $dbpassword,
    $dbserver,
    $dbsocket
) {

  # This version of activerecord works with Ruby 1.8.5 and Centos 5.
  # This ensure should be fixed.
  package {'activerecord':
    ensure => '2.2.2',
    provider => gem,
  }

  case $dbadapter {
    'sqlite3': {
      include puppet::storeconfigs::sqlite
    }
    'mysql': {
      class {
        "puppet::storeconfigs::mysql":
          dbuser     => $dbuser,
          dbpassword => $dbpassword,
      }
    }
    default: { err("target dbadapter $dbadapter not implemented") }
  }

  concat::fragment { 'puppet.conf-master-storeconfig':
    order   => '06',
    target  => "/etc/puppet/puppet.conf",
    content => template("puppet/puppet.conf-master-storeconfigs.erb");
  }

}

