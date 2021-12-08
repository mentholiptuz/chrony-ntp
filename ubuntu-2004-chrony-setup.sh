#!/bin/bash
clear
echo "***************************"
echo "Setup script was started"
echo "***************************"
date
echo "***************************"
echo "The current status of configuration via timedatectl and timesyncd"
sudo timedatectl status
echo "***************************"
sleep 5
clear
echo "***************************"
echo "Set timezone Asia/Bangkok"
echo "***************************"
sudo timedatectl set-timezone Asia/Bangkok
echo "***************************"
echo "Running update and then upgrade Ubuntu"
echo "***************************"
sudo apt update && sudo apt upgrade -y
sleep 5
clear
echo "***************************"
echo "Start install Chrony"
echo "***************************"
sudo apt install chrony -y
sleep 5
clear
echo "***************************"
echo "Start Chronyd"
echo "***************************"
sudo systemctl start chronyd
sudo systemctl status chronyd
sleep 5
clear
echo "***************************"
echo "Chronyd service status"
echo "***************************"
sudo systemctl status chronyd
sleep 5
clear
echo "***************************"
echo "Check the number of connected servers and peers"
echo "***************************"
chronyc activity
sleep 5
clear
sudo bash -c 'cat <<EOF > /etc/chrony/chrony.conf
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usuable directives.

# This will use (up to):
# - 4 sources from ntp.ubuntu.com which some are ipv6 enabled
# - 2 sources from 2.ubuntu.pool.ntp.org which is ipv6 enabled as well
# - 1 source from [01].ubuntu.pool.ntp.org each (ipv4 only atm)
# This means by default, up to 6 dual-stack and up to 2 additional IPv4-only
# sources will be used.
# At the same time it retains some protection against one of the entries being
# down (compare to just using one of the lines). See (LP: #1754358) for the
# discussion.
#
# About using servers from the NTP Pool Project in general see (LP: #104525).
# Approved by Ubuntu Technical Board on 2011-02-08.
# See http://www.pool.ntp.org/join.html for more information.
#pool ntp.ubuntu.com        iburst maxsources 4
#pool 0.ubuntu.pool.ntp.org iburst maxsources 1
#pool 1.ubuntu.pool.ntp.org iburst maxsources 1
#pool 2.ubuntu.pool.ntp.org iburst maxsources 2
pool time.google.com      iburst maxsources 4

# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony/chrony.keys

# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/chrony.drift

# Uncomment the following line to turn logging on.
#log tracking measurements statistics

# Log files location.
logdir /var/log/chrony

# Stop bad estimates upsetting machine clock.
maxupdateskew 100.0

# This directive enables kernel synchronisation (every 11 minutes) of the
# real-time clock. Note that it can’t be used along with the 'rtcfile' directive.
rtcsync

# Step the system clock instead of slewing it if the adjustment is larger than
# one second, but only in the first three clock updates.
makestep 1 3

# To enable serving the NTP protocol you’ll need at least to set the allow rule to which controls which clients/networks you want chrony to serve NTP to set allow
allow 192.168.1.0/24
EOF'
echo "***************************"
echo "Restarting Chronyd"
echo "***************************"
sudo systemctl restart chronyd
sudo systemctl status chronyd
sleep 5
clear
echo "***************************"
echo "Synchronize the servers"
echo "***************************"
sudo timedatectl set-ntp true
sudo timedatectl status
sleep 5
echo "***************************"
echo "Use chronyc to see query the status of the chrony daemon"
echo "***************************"
chronyc sources -v
sleep 8
clear
echo "***************************"
echo "Use chronyc to see query stats the status of the chrony daemon"
echo "***************************"
chronyc sourcestats -v
sleep 8
clear
echo "***************************"
echo "Check the server chrony is tracking with its performance metrics"
echo "***************************"
chronyc tracking
sleep 8
echo == END
