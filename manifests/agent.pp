# Class: puppet::agent
#
# This class installs and configures the puppet agent
#
# Parameters:
#
# Actions:
# 
# Requires:
#
# Sample Usage:
#
class puppet::agent(
  $puppet_defaults,
  $puppet_agent_service,
  $puppet_agent_name,
  $puppet_conf,
  $puppet_server,
  $version
) inherits puppet::params {
  
  if $kernel == "Linux" {
    file { $puppet_defaults:
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/puppet/${puppet_defaults}",
    }
  }

  package { 'puppet':
    name   => $puppet_agent_name,
    ensure => $version,
  }

  service { "puppet_agent":
    name       => "$puppet_agent_service",
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => Concat[$puppet_conf],
  }

  concat::fragment { 'puppet.conf-common':
    order   => '00',
    target  => $puppet_conf,
    content => template("puppet/puppet.conf-common.erb"),
  }

  concat { $puppet_conf:
    mode    => '0644',
    require => Package['puppet'],
    notify  => Service['puppet_agent'],
  }

}

