#!/bin/bash

echo -e "\e[1;32m"

echo "
 ######   ########  ######          ##     ##  #######   #######  
##    ##  ##       ##    ##         ###   ### ##     ## ##     ## 
##        ##       ##               #### #### ##     ## ##     ## 
##   #### ######    ######  ####### ## ### ## ##     ## ##     ## 
##    ##  ##             ##         ##     ## ##     ## ##     ## 
##    ##  ##       ##    ##         ##     ## ##     ## ##     ## 
 ######   ##        ######          ##     ##  #######   #######

 This Script will install Gluster File System for moodle

Check list before you go to next steps :-

>> Launch three ec2 instance with Ubuntu OS
>> The Public IP of EC2 Instances (Assign Elastic IP for production)
>> Make sure your Security groups have ports opened as shown below
    22,24007,111,49152-49251,2049
 
 "
echo -e "\e[1;32m"

echo -e "\e[1;37m >> Updating the OS and installing the dependencies\e[0m"

sudo apt update -y &>> debug.txt | echo "  >> updating . . . . ."
sudo apt upgrade -y &>> debug.txt 

ip1=13.239.46.44
ip2=13.238.19.149
ip3=3.106.42.92
# ebter moodle data directory location path ex: 

data_dir=/var/www/html/moodle/moodledata

echo -e "\e[1;34m \n  Pinging the Gluster Nodes to make sure they are up and running.
 #################################################################\e[0m" 
echo -e "\e[1;37m The IPs of the Gluster Nodes are: $ip1, $ip2, $ip3"
echo -e "\e[0m"


    ping -c 1 $ip1 1> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[1;37m  >> Gluster Node 1 - $ip1 is reachable"
    else
        echo -e "\e[1;31m  >> Gluster Node 1 - $ip1 is not reachable"
        echo -e "\e[0m"
        exit 1
    fi

    ping -c 1 $ip2 1> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[1;37m  >> Gluster Node 2 - $ip2 is reachable"
    else
        echo -e "\e[1;31m  >> Gluster Node 2 - $ip2 is not reachable"
        echo -e "\e[0m"
        exit 1
    fi

    ping -c 1 $ip3 1> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[1;37m  >> Gluster Node 3 - $ip3 is reachable"
        echo -e "\e[0m"
    else
        echo -e "\e[1;31m  >> Gluster Node 3 - $ip3 is not reachable"
        echo -e "\e[0m"
        exit 1
    fi




echo -e "\e[1;34m \n  Please select your current HOST to be used for the GlusterFS cluster 
 #################################################################\e[0m" 
echo -e "\e[1;37m\n 1. GlusterFs-01 \e[0m"
echo -e "\e[1;37m 2. GlusterFs-02 \e[0m"
echo -e "\e[1;37m 3. GlusterFs-03 \e[0m" 
echo -e "\e[1;32m"
read -p "Enter your choice:" option
echo -e "\e[0m"
if [ $option == "1" ]
then
    echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs-01\e[0m"
    #hostname="glusterfs-01"
    #echo $hostname > /etc/hostname
    hostnamectl set-hostname glusterfs-01
    echo "127.0.0.1 $hostname" > /etc/hosts
    echo "$ip2  glusterfs-02" >> /etc/hosts
    echo "$ip3  glusterfs-03" >> /etc/hosts
    
else
    if [ $option == "2" ]
    then
        echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs-02\e[0m"
        #hostname="glusterfs-02"
        #echo $hostname > /etc/hostname
        sudo hostnamectl set-hostname glusterfs-02
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  glusterfs-01" >> /etc/hosts
        echo "$ip3  glusterfs-03" >> /etc/hosts
    else
        if [ $option == "3" ]
        then
        echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs-03\e[0m"
        #hostname="glusterfs-03"
        #echo $hostname > /etc/hostname
        sudo hostnamectl set-hostname glusterfs-03
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  glusterfs-01" >> /etc/hosts
        echo "$ip2  glusterfs-02" >> /etc/hosts
        else
        echo -e "\e[1;31m  >> Your input is invalid - \e[1;32m $option \n\e[0m"
        exit 1
        fi
        
    fi
fi
 echo -e "\e[1;37m  >> ip addresses written to /etc/hosts"
 echo -e "\e[1;37m  >> Hostname written to /etc/hostname - you are on $hostname"
        echo -e "\e[0m"


echo -e "\e[1;34m \n  Installing GlusterFS and Dependencies
 #######################################\e[0m"
echo -e "Sit back and relax installing all dependencies  \n\e[0m"

sudo apt install software-properties-common -y &>> debug.txt | echo " >> Installing software-properties-common . . . . ."
echo -e "\e[1;37m  >> Installed software-properties-common  [\e[1;32mOK\e[1;37m]\e[0m"

sudo add-apt-repository ppa:gluster/glusterfs-7 -y &>> debug.txt | echo " >> Adding Gluster repository . . . . ."
echo -e "\e[1;37m  >> GlusterFS repository (glusterfs-7) added [\e[1;32mOK\e[1;37m]\e[0m"

sudo apt-get update -y &>> debug.txt | echo " >> updating . . . . ."
echo -e "\e[1;37m  >> apt update [\e[1;32mOK\e[1;37m]\e[0m"

sudo apt install glusterfs-server -y &>> debug.txt | echo " >> Installing GlusterFS server . . . . ."
echo -e "\e[1;37m  >> GlusterFS Server installed [\e[1;32mOK\e[1;37m]\e[0m"

sudo systemctl start glusterd &>> debug.txt | echo " >> Starting GlusterFS server . . . . ."
echo -e "\e[1;37m  >> GlusterFS Server started [\e[1;32mOK\e[1;37m]\e[0m"

sudo systemctl enable glusterd &>> debug.txt | echo " >> Enabling GlusterFS server . . . . ."
echo -e "\e[1;37m  >> GlusterFS Server enabled [\e[1;32mOK\e[1;37m]\e[0m"


mkdir -p /glusterfs
echo -e "\e[1;37m\n  >> /glusterfs folder Createdd [\e[1;32mOK\e[1;37m]\e[0m"
echo -e "\e[1;37m Installation Complete - Start peering"
echo -e "\e[0m"


echo -e "\e[1;34m \n  Probing GlusterFS Nodes
 #######################################\e[0m"

host=$(hostname)

if [ "$host" == "glusterfs-01" ] ;
 then
    echo -e "\e[1;37m\n  >> Setting GlusterFS-01 as the Master node\e[0m"
    echo -e "\e[1;37m  >> Probing GlusterFS-02\e[0m" && gluster peer probe glusterfs-02 
    echo -e "\e[1;37m  >> Probing GlusterFS-03\e[0m" && gluster peer probe glusterfs-03 
    echo -e "\e[1;37m  >>  Creating GlusterFS volume gv0\e[0m" && sudo gluster volume create gv0 replica 3 transport tcp glusterfs-01:/glusterfs glusterfs-02:/glusterfs glusterfs-03:/glusterfs force
    echo -e "\e[1;37m  >> Starting GlusterFS volume gv0\e[0m" && sudo gluster volume start gv0
    echo -e "\e[1;37m  >>  GlusterFS volume info\e[0m" && sudo gluster volume info

 else
 echo -e "\e[1;37m  >> This is not GlusterFS-01 , Script is running on $host so skipping Master Node Setup \e[0m "
 fi
 
echo -e "\e[1;32m\n  ***Instalation Complete****\e[0m"