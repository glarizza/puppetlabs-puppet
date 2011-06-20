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
    $storeconfigs_dbadapter,
    $storeconfigs_dbuser,
    $storeconfigs_dbpassword,
    $storeconfigs_dbserver,
    $storeconfigs_dbsocket
) {

  case $dbadapter {
    'sqlite3': {
      include puppet::storeconfig::sqlite
    }
    'mysql': {
      class { 
        "puppet::storeconfigs::mysql": 
          dbuser     => $storeconfigs_dbuser,
          dbpassword => $storeconfigs_dbpassword,
      }
    }
    default: { err("targer dbadapter $storeconfigs_dbadapter not implemented") }
  }

  concat::fragment { 'puppet.conf-master-storeconfig':
    order   => '06',
    target  => "/etc/puppet/puppet.conf",
    content => template("puppet/puppet.conf-master-storeconfigs.erb");
  }

}

