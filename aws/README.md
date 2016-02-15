### SOME USEFUL COMMANDS

    ansible -i inventory/ec2.py eu-central-1 --list-hosts
    ansible -i inventory/ec2.py eu-west-1 --list-hosts

### CREATE NEW EC2 INSTANCES
    ansible-playbook -i inventory/ec2.py ec2-create.yml -u root

### PROVISION EC2 LOADBALANCER
   

### PROVISION EC2 WEBSERVERS
 


### Ansible environment


### Configuration || Access
need to add keys with aws access, information on where to find the keys will be added when we know where/how to share it safely.

    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=

### ec2_location and inventory


### Create, start and stop.




