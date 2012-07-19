class sauceconnect(
  $sauce_user,
  $sauce_key
) {

  package {
    [ 'openjdk-6-jre', 'unzip' ]:
      ensure => present,
  }

  exec { "Download Sauce-Connect-latest.zip file":
    command => "/usr/bin/wget http://saucelabs.com/downloads/Sauce-Connect-latest.zip",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/Sauce-Connect-latest.zip",
  }

  exec { "Unzip Sauce-Connect-latest.zip file":
    command => "/usr/bin/unzip Sauce-Connect-latest.zip",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/Sauce-Connect.jar",
    require => Exec["Download Sauce-Connect-latest.zip file"]
  }

  file { "/opt/saucelabs":
    ensure => directory,
  }

  file { "/opt/saucelabs/Sauce-Connect.jar":
    source => '/usr/local/src/Sauce-Connect.jar',
    require => Exec ["Unzip Sauce-Connect-latest.zip file"],
  }

  file { "/etc/init.d/sauceconnect":
    content => template('sauceconnect/sauceconnect.erb'),
    mode    => '755',
  }

  service { 'sauceconnect':
    enable   => true,
    ensure   => "running",
    hasstatus  => true,
    hasrestart => false,
    require => Exec["Download Sauce-Connect-latest.zip file"]
  }

}
