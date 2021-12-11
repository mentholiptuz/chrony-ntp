ssh-keygen
mkdir ntpservers
cp /etc/ansible/ansible.cfg ~/administrator/
vi ~/administrator/ansible.cfg

# Add below line under [default]
inventory      = /home/sysops/administrator/inventory
remote_user = sysops
host_key_checking = False

# Add below line under [privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False


vi ~/administrator/inventory

# Add Server List to inventory file
[ntpservers]
timeserver01.ntpserver.local
timeserver02.ntpserver.local
timeserver03.ntpserver.local
timeserver04.ntpserver.local

export ANSIBLE_CONFIG=/home/sysops/demo/ansible.cfg

alias chronycstatus="ansible all -m shell -a 'chronyc activity;chronyc sources -v;chronyc tracking'"