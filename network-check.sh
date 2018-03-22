#!/bin/bash
 
ip=( "146.88.106.210 -p 443"
 
     "146.88.106.197 -p 4119"
 
     "146.88.106.197 -p 4120"
 
     "146.88.106.197 -p 4122"
 
     "146.88.106.196 -p 515"
 
     "146.88.106.200 -p 8443"
 
     "146.88.106.216 -p 443"
 
     "cloud.tenable.com -p 443" )
 
if ! which nmap > /dev/null
 
then
 
  echo "$(/usr/bin/tput setaf 1)nmap is not installed. Stoping connectivity check.$(/usr/bin/tput sgr0)"
 
  exit 1
 
else
 
  for i in "${ip[@]}"
 
     do
 
      if nmap -P0 $i > /dev/null 2>&1
 
      then
 
        echo "$(tput setaf 2)Connection to $i was successful.$(tput sgr0)"
 
      else
 
        echo "$(tput setaf 1)Connection to $i failed. $(tput setab 7)Please check firewall rules are in place for $i $(tput sgr0)"
	exit # bail, something didnt connect, we do NOT move forward with agent install.
 
      fi
 
  done

# we assume all ports and ip's were available, install the agent.

# handle RHEL and CentOS
if [ -f /etc/redhat-release ]
	then
		rpm -Uvh /tmp/armor-agent.rpm
		/opt/armor/armor register --license=`cat /tmp/LICENSE.file`
	elif [ -f /etc/debian_version ]
		then
			/usr/bin/dpkg --install /tmp/armor-agent.deb
			/opt/armor/armor register --license=`cat /tmp/LICENSE.file`
		else
			echo "Unsupported OS, exiting."
	fi
fi
