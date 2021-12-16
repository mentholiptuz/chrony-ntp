# Setup SSH keys and share it among managed nodes
ssh-keygen

# To share the ssh keys between control to managed hosts, run ssh-copy-id command
ssh-copy-id timeserver01.ntpserver.local
ssh-copy-id timeserver02.ntpserver.local
ssh-copy-id timeserver03.ntpserver.local
ssh-copy-id timeserver04.ntpserver.local

# Create ansible cfg and inventory file
mkdir ntpservers
cp /etc/ansible/ansible.cfg ~/ntpservers/
vi ~/ntpservers/ansible.cfg

# Add below line under [default]
inventory      = /home/administrator/ntpservers/inventory
remote_user = administrator
host_key_checking = False

# Add below line under [privilege_escalation]
become=True
become_method=sudo
become_user=root
become_ask_pass=False

vi ~/administrator/ntpservers/inventory

# Add Server List to inventory file
[ntpservers]
timeserver01.ntpserver.local
timeserver02.ntpserver.local
timeserver03.ntpserver.local
timeserver04.ntpserver.local

# Declaring ANSIBLE_CONFIG variable
export ANSIBLE_CONFIG=/home/administrator/ntpservers/ansible.cfg
echo "export ANSIBLE_CONFIG=/home/administrator/ntpservers/ansible.cfg" >> ~/.profile
alias chronycstatus="ansible all -m shell -a 'chronyc activity;chronyc sources -v;chronyc tracking'"
