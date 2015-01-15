class profile::consul_agent(
  $log_level  = 'INFO',
) {
  ### Setup Consul Node ###
  $_config_hash = {
    'data_dir'         => '/opt/consul',
    'log_level'        => $log_level,
    'start_join'       => hiera_array('consul_agent::join_cluster', []),
    'datacenter'       => $::datacenter,
  }

  if !defined(Class['role::consul_cluster']) {
    class { '::consul':
      config_hash    => $_config_hash,
      join_cluster   => $join_cluster,
      service_enable => true,
      service_ensure => 'running',
    }

    # Setup DNSMasq for automatic awesomeness
    include ::dnsmasq
    dnsmasq::dnsserver { 'consul':
      ip     => '127.0.0.1#8600',
      domain => 'consul',
    }
  }
  ### END Setup Consul ###
}