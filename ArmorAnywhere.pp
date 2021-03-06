
# Send the Anywhere license file, customer needs to add their code to this file.
class pushLicense {
file { "/tmp/LICENSE.file":
  mode   => "0644",
  owner  => "root",
  group  => "root",
  source =>  'puppet:///modules/armor/LICENSE',
  }
}

# Install Anywhere on RHEL/CentOS/Amazon
class installRHEL {
 exec { 'InstallAnywhere':
	command => '/bin/rpm -Uvh /tmp/armor-agent.rpm'
	}
 }

# Install Anywhere on Ubuntu
class installUbuntu {
 exec { 'InstallAnywhere':
	command => '/usr/bin/dpkg -i /tmp/armor-agent.deb'
	}
 }

# register Anywhere
class registerAnywhere {
 exec { 'RegisterAnywhere':
	command => '/opt/armor/armor register --license=`cat /tmp/LICENSE.file`'
	}
 }

# identify Linux Distro, and version.
class osDetection {

case $::operatingsystem {
    'CentOS','RedHat' : {
    case $::operatingsystemmajrelease {

    '7': {
    include ::osDetection::centos::seven
    }

    '6': {
    include ::osDetection::centos::six
    }
  
  default:  {
  fail "Unsupported RedHat or CentOS version.. '${::lsbmajdistrelease}' in 'osDetection' module."
    }
   }
  }

   'Ubuntu': {
    case $::lsbdistcodename {
    
  'Xenial': { # 16.04
    include ::osDetection::ubuntu::xenial
    }

  'Trusty': { # 14.04
    include ::osDetection::ubuntu::trusty
  } 

  'Precise': { # 12.04
  include ::osDetection::ubuntu::precise 
  }

  default:  {
  fail "Unsupported Ubuntu version..'${::lbdistcodename}' in 'osDetection' module."
        }
      }
     }

'Amazon': {
    case $::operatingsystemmajrelease {

    '2': {
    include ::osDetection::amazon::two
    }

    default: {
    fail "Unsupported Amazon Linux version.. '{{::operatingsystemmajrelease}' in 'osDetection' module."
        }
    }
}
 }
}

# Amazon
class osDetection::amazon::two {
 Exec { 'Get-Agent':
 path    => ['/bin:/usr/bin:/usr/sbin'],
 command =>  'wget https://get.core.armor.com/latest/armor-agent.rpm -O /tmp/armor-agent.rpm'
      }
# install these packages if not already there.
 $packages = [ 'nmap', 'curl', 'wget', 'yum-utils' ]
 package {
 $packages:
 ensure => "installed"
  }
 include ::pushLicense
}

# RedHat/CentOS
class osDetection::centos::seven {
  Exec { 'Get-Agent':
  path    => ['/bin:/usr/bin:/usr/sbin'],
  command =>  'wget https://get.core.armor.com/latest/armor-agent.rpm -O /tmp/armor-agent.rpm'
  }

# install these packages if not already on the server.
$packages = [ 'nmap', 'curl', 'wget', 'yum-utils' ]
  package {
      $packages:
                  ensure =>  "installed"
  }

include ::installRHEL
include ::pushLicense
include ::registerAnywhere

}
class osDetection::centos::six {
    Exec { 'Get-Agent':
  path    => ['/bin:/usr/bin:/usr/sbin'],
  command =>  'wget https://get.core.armor.com/latest/armor-agent.rpm -O /tmp/armor-agent.rpm'
  }

# install these packages if not already on the server.
$packages = [ 'nmap',  'wget', 'yum-utils' ]
  package {
  $packages:
  ensure =>  "installed"
  }

include ::pushLicense
include ::installRHEL
include ::registerAnywhere

}


# Ubuntu
 class osDetection::ubuntu::xenial {
   Exec { 
   'get-agent' : command =>  '/usr/bin/wget https://get.core.armor.com/latest/armor-agent.deb',
    path  => ['/usr/bin'],
  }

  # install these packages if not already on the server.
  $packages = [ 'nmap',  'wget' ]
    package {
         $packages:
         ensure =>   "installed"
            }

 include ::pushLicense

}

 class osDetection::ubuntu::trusty {
  Exec {
  'get-agent' : command =>   'wget https://get.core.armor.com/latest/armor-agent.deb',
   path	=> ['/usr/bin'],
 }

# install these packages if not already on the server.
  $packages = [ 'nmap',  'wget' ]
    package {
     $packages:
      ensure =>    "installed"
   }

include ::pushLicense

}

 class osDetection::ubuntu::precise {
 Exec {
 'get-agent' : command =>   'wget https://get.core.armor.com/latest/armor-agent.deb',
  path	=>	['/usr/bin'],
}

# install these packages if not already on the server.
  $packages = [ 'nmap',  'wget' ]
   package {
    $packages:
     ensure =>    "installed"
  }

include ::pushLicense
}


include ::osDetection

