class kibana3 {
  $dlcmd = "curl -o"
  $kibana_gz = "https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz"
  $kibana_dir = "/usr/share/kibana"
  $kibana_local = "/root/kibana.tar.gz"
  file { 'kibana_dir':
    path => "/usr/share/kibana",
    ensure => directory,
    mode => 775
  }
  exec { 'download_kibana':
    command => "${dlcmd} ${kibana_local} ${kibana_gz} 2> /dev/null",
    path => ['/usr/bin', '/bin'],
    creates => $kibana_local,
    require => File['kibana_dir'],
  }
  exec { 'untar_kibana':
    command => "tar zxvf ${kibana_local} -C ${kibana_dir} 2> /dev/null",
    path => ['/usr/bin', '/bin'],
    require => File['kibana_dir'],
    creates => '/usr/share/kibana/kibana-3.1.0/'
  }
  file { "kibana_config":
    path => "/usr/share/kibana/kibana-3.1.0/config.js",
    source => "puppet:///modules/kibana3/config.js",
  }
  File['kibana_dir']
  -> Exec['download_kibana']
  -> Exec['untar_kibana']
  -> File['kibana_config']
}
