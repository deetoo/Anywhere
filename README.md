# Armor Anywhere Puppet manifest

This manifest is a work in progress. (read: very very ALPHA!)

### what works
- ArmorAnywhere.pp will verify all prerequisites for RHEL/CentOS and (as of 1.1) Ubuntu, and install, and register Anywhere.

### what is still being worked on
- AWS Linux support.

### what is needed
- you need a valid license code to register Anywhere, you know where to find this if you are a customer.

### CHANGELOG
- 1.0a initial commit
- 1.1a added support for Ubuntu 12/14/16

### LATEST VERSION
- 1.2a removed outbound connectivity check, as succesful heartbeat is needed before ports are opened.


### TODO:
