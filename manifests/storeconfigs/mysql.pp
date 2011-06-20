class puppet::storeconfigs::mysql (
    $storeconfigs_dbuser,
    $storeconfigs_dbpassword
  ){

  include puppet::params

   package { $puppet::params::puppet_storeconfigs_packages:
     ensure => installed,
   }

   package { 'mysql':
     ensure   => installed,
     provider => 'gem',
   }

   database{ 'puppet':
     ensure  => present,
     charset => 'utf8',
   }

   database_user{"$dbuser@localhost":
     ensure        => present,
     password_hash => mysql_password($storeconfigs_dbpassword),
     require       => Database['puppet'],
   }
 
   database_grant{ 'puppet@localhost/puppet':
     privileges => [all],
     require    => [ Database['puppet'], Database_user['puppet@localhost'] ],
   }


}
