# First, verify the needed IP's and ports can be connected to from the server.
class portCheck {
file { "/tmp/network.sh":
  mode   => "0755",
  owner  => "root",
  group  => "root",
  source => 'puppet:///modules/agent/network-check.sh',
  }
}

# Send the Anywhere license file, customer needs to add their code to this file.
class pushLicense {
file { "/tmp/LICENSE.file":
  mode   => "0644",
  owner  => "root",
  group  => "root",
  source => 'puppet:///modules/agent/LICENSE',
  }
}

class checkUbuntu {
	if $operatingsystem == 'Ubuntu' {
	# do stuff
	exec { 'get-agent' : command => 'wget https://get.core.armor.com/latest/armor-agent.deb'  
	}
	}
}


class checkRedhat {
	if $operatingsystem == 'CentOS' {
	# do stuff
	Exec { 'Get-Agent':
  path                   => ['/bin:/usr/bin:/usr/sbin'],
  command                => 'wget https://get.core.armor.com/latest/armor-agent.rpm -O /tmp/armor-agent.rpm' 
	}

# install these packages if not already on the server.
$packages = [ 'nmap', 'git', 'curl', 'wget', 'yum-utils' ]
  package { 
      $packages: 
                  ensure => "installed"
  }

include ::pushLicense
include ::portCheck

# Run the network/port script on the server.
exec	{ '/tmp/network.sh':
		command	=> '/tmp/network.sh >/tmp/ports.txt',
		path	=> ['/bin'],
  }

 }
}

include ::checkUbuntu
include ::checkRedhat
