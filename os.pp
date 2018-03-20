# identify Linux Distro, and version.
class os {
case $::operatingsystem {

    'Ubuntu': {
    case $::lsbdistcodename {
    
  'Xenial': { # 16.04
    include ::os::ubuntu::xenial
    }

  'Trusty': { # 14.04
    include ::os::ubuntu::trusty
  } 

  'Precise': { # 12.04
  include ::os::ubuntu::precise 
  }

  default:  {
  fail "Unsupported Ubuntu version..'${::lbdistcodename}' in 'os' module."
        }
      }
  }
    'CentOS','RedHat' : {
    case $::operatingsystemmajrelease {

    '7': {
    include ::os::centos::seven
    }

    '6': {
    include ::os::centos::six
    }
  
  default:  {
  fail "Unsupported RedHat or CentOS version.. '${::lsbmajdistrelease}' in 'os' module."
    }
   }
  }
 }
}

# RedHat/CentOS

class os::centos::seven {
file { '/tmp/centos.7.txt':
    ensure => present,
    mode   => '0444',
  }
}

class os::centos::six {
file { '/tmp/centos.6.txt':
  ensure => present,
  mode   => '0444',
  }
}

# Ubuntu
class os::ubuntu::xenial {
file { '/tmp/ubuntu.xenial.txt':
      ensure => present,
      mode   => '0444',
  }
}

class os::ubuntu::trusty {
file { '/tmp/ubuntu.trusty.txt':
    ensure => present,
    mode   =>  '0444',
  }
}

class os::ubuntu::precise {
file { '/tmp/ubuntu.precise.txt':
  ensure => present,
  mode   => '0444',
  }
}

class os::centos {
file  { '/tmp/centos.txt':
      ensure => present,
      mode   => '0444',
  }
}

include ::os
