#!/bin/bash


# Get the IP of the Gluster Nodes
echo -e "\e[1;34m"
cat assets/logo.txt 
echo -e "\e[1;32m"
read -p "Enter GlusterFS-01 Node IP:" ip1
read -p "Enter GlusterFS-02 Node IP:" ip2
read -p "Enter GlusterFS-03 Node IP:" ip3
echo -e "\e[0m" 


echo -e "\e[1;37m  >> Updating the OS and installing the dependencies\e[0m"
apt install pv -y &>> debug.txt 
sudo apt update -y &>> debug.txt | pv -ls 100
sudo apt upgrade -y &>> debug.txt | pv -ls 100




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
echo -e "\e[1;37m\n 1. GlusterFs01 \e[0m"
echo -e "\e[1;37m 2. GlusterFs02 \e[0m"
echo -e "\e[1;37m 3. GlusterFs03 \e[0m" 
echo -e "\e[1;32m"
read -p "Enter your choice:" option
echo -e "\e[0m"
if [ $option == "1" ]
then
    echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs01\e[0m"
    hostname="glusterfs01"
    echo $hostname > /etc/hostname
    echo "127.0.0.1 $hostname" > /etc/hosts
    echo "$ip2  glusterfs02" >> /etc/hosts
    echo "$ip3  glusterfs03" >> /etc/hosts
    
else
    if [ $option == "2" ]
    then
        echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs02\e[0m"
        hostname="glusterfs02"
        echo $hostname > /etc/hostname
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  glusterfs01" >> /etc/hosts
        echo "$ip3  glusterfs03" >> /etc/hosts
    else
        if [ $option == "3" ]
        then
        echo -e "\e[1;37m  >> You have selected \e[1;32m glusterfs03\e[0m"
        hostname="glusterfs03"
        echo $hostname > /etc/hostname
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  glusterfs01" >> /etc/hosts
        echo "$ip2  glusterfs02" >> /etc/hosts
        else
        echo -e "\e[1;31m  >> Your inpur is invalid \e[1;32m $option \n\e[0m"
        exit 1
        fi
        
    fi
fi




 echo -e "\e[1;37m  >> ip addresses written to /etc/hosts"
 echo -e "\e[1;37m  >> ip Hostname written to /etc/hostname - you are on $hostname"
        echo -e "\e[0m"


echo -e "\e[1;34m \n  Installing GlusterFS and Dependencies
 #######################################\e[0m"

echo -e "Sit back and relax installing all dependencies  \n\e[0m"

sudo apt install software-properties-common -y &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> Installed software-properties-common  [\e[1;32mOK\e[1;37m]\e[0m"

sudo add-apt-repository ppa:gluster/glusterfs-7 -y &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> GlusterFS repository (glusterfs-7) added [\e[1;32mOK\e[1;37m]\e[0m"

sudo apt-get update -y &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> apt update [\e[1;32mOK\e[1;37m]\e[0m"

sudo apt install glusterfs-server -y &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> GlusterFS Server installed [\e[1;32mOK\e[1;37m]\e[0m"

sudo systemctl start glusterd &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> GlusterFS Server started [\e[1;32mOK\e[1;37m]\e[0m"

sudo systemctl enable glusterd &>> debug.txt | pv -ls 100
echo -e "\e[1;37m  >> GlusterFS Server enabled [\e[1;32mOK\e[1;37m]\e[0m"

# Create a nested folder
mkdir -p /glusterfs

echo -e "\e[1;37m\n  >> /glusterfs folder Createdd [\e[1;32mOK\e[1;37m]\e[0m"


echo -e "\e[1;37m Installation Complete - Start peering"
echo -e "\e[0m"

