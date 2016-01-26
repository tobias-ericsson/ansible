### SOME USEFUL COMMANDS
    common/inventory/ec2.py
    ansible -i common/inventory/ec2.py eu-central-1 --list-hosts
    ansible -i common/inventory/ec2.py eu-west-1 --list-hosts

### CREATE NEW EC2 INSTANCES
    cd common
    ansible-playbook -i inventory/ec2.py ec2-create.yml -u root

### PROVISION EC2 LOADBALANCER
    cd infrastructure
    ansible-playbook -i ../common/inventory/ec2.py ec2-loadbalancer.yml -u centos

### PROVISION EC2 WEBSERVERS
    cd stack
    ansible-playbook -i ../common/inventory/ec2.py ec2-web.yml -u centos


### Ansible environment

clone || setup standard DevOps ansible repository

To work with aws/ec2 we need to add python modules

$ cd ansible

$ venv/bin/pip install boto

$ venv/bin/pip install six

### Configuration || Access
need to add keys with aws access, information on where to find the keys will be added when we know where/how to share it safely.

    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=

### ec2_location and inventory
Today we have machines in two places: 
* frankfurt aka eu-central-1
* ireland aka eu-west-1

The inventory/ec2.py script fetches information about the different locations and hosts.

    ansible -i common/inventory/ec2.py eu-central-1 --list-hosts
    ansible -i common/inventory/ec2.py eu-west-1 --list-hosts

### Create, start and stop.
Three playbooks exists to automate creation, start and stop of AWS instances that are managed by DevOps. Today we use two tags, tag_ansible_group_web and tag_ansible_group_loadbalancer

When creating new instances a few questions will be asked.

    common/ec2-create.yml
      vars_prompt:
      ec2_location: "frankfurt or ireland"
      ec2_instance_count: "How many instances"
      ec2_tag_name: "Tag Name"
      ec2_tag_ansible_group: "Tag ansible_group"
      ec2_tag_ansible_role: "Tag ansible_role"

The ec2_tag_name: "Tag Name" will generate a name so if we create ec2_instance_count = 10 and ec2_tag_name = web we will get 10 servers with the same name. In this version the remaning must be done using the WebUI. 

It is important to use the same tags when creating new machines, or else the other playbooks will not find the hosts. This is how the "hosts:" are found. 

    hosts:
    - tag_ansible_group_web
    - tag_ansible_group_loadbalancer
	
    common/ec2-start.yml
    common/ec2-stop.yml

### Network layout
Frankfurt - eu-central-1

Two networks

Public IP: ec2_ip_address : 52.29.?.?
Private IP: ec2_private_ip_address : 172.31.?.?

All Public IPs are NAT:et from Amazon and all communication between hosts in the same cloud uses the Private IP.


### Todo || Questions
- Generate unique names, ec2_tag_name based on Tag and ec2_instance_count?
- Create Mobenga CentOS image - CentOS images from Cloud services have different users depending on location.
- Passwords - We have more than one account on AWS, should enforce passwd policy on all.
- SSH-Key management - TeamCity has a user with ssh-key and access to aws. Should enforce passwd policy and create a way to securely grant correct access
- Group access (DevOps, ngen) with correct personal key mgmt
- Config, startopts - 
- Firewall rules - Add correct access and a smart way of keeping it up-to-date.
- HTTPS support, was it a Loki issue or an "invalid" cert due to missing dns entry?
- Aws InstanceType? Do we want to have the same size?  Sized like CustomerX or Staging? 
- IP-addresses and whitelisting? To access rpm.mobenga.com the source-address needs to be whitelisted. We have lots of options, # ip route add 141.255.187.5/32 via 172.31.4.255, or install squid and configure yum to use a proxy, local cache on loadbalancer (or other host), or whitelist all of amazon.
- Network layout. Should we look into a layered design where loadbalancer, webserver and LoadTest-host is on different networks?
- DNS and hostnames. Think of a smart way to manage this.
- LoadBalancer, is it interesting to test F5 which is the most Customer-like LoadBalancer?
- Scheduled shutdown? make sure we do not use more resources than needed.
- Billing alert


