#!/bin/bash

 # Update Ubuntu
function update-ubuntu {
            echo -e "\e[0m"
            echo -e "\e[1;37m [+] Updating the OS and installing the dependencies\e[0m"
            sudo apt update -y &>> debug.txt 
            sudo apt upgrade -y &>> debug.txt   
            echo -e "  >> Update and Upgrade complete  [\e[1;32mOK\e[1;37m]\e[0m"
}
 # install LAMP server
function lamp-server {
                echo -e "\e[1;34m \n  Installing LAMP server.
 #################################################################\e[0m\n" 
        sudo apt install lamp-server^ -y  &>> debug.txt | echo -e "\e[1;37m [+] Installing LAMP . . . . .\e[0m"
        echo -e "  >> Installed LAMP  [\e[1;32mOK\e[1;37m]\e[0m"
        
        sudo apt install php-mbstring php-curl php-xmlrpc php-soap php-zip php-gd php-xml php-intl php-json -y &>> debug.txt | echo -e "\e[1;37m [+] Installing php-mbstring,php-curl,php-xmlrpc,php-soap,php-zip,php-gd,php-xml,php-intl,php-json . . . . .\e[0m"
        echo -e "  >> Installed php-mbstring,php-curl,php-xmlrpc,php-soap,php-zip,php-gd,php-xml,php-intl,php-json  [\e[1;32mOK\e[1;37m]\e[0m"
        
        sudo service apache2 restart &>> debug.txt | echo -e "\e[1;37m [+] Restarting Apache . . . . .\e[0m"
        echo -e "  >> Restarted Apache  [\e[1;32mOK\e[1;37m]\e[0m"

        sudo a2enmod rewrite &>> debug.txt | echo -e "\e[1;37m [+] Enabling mod rewrite . . . . .\e[0m"
        echo -e "  >> Enabled mod rewrite  [\e[1;32mOK\e[1;37m]\e[0m"
        sudo service apache2 restart | echo -e "\e[1;37m [+] Restarting Apache . . . . .\e[0m"
        echo -e "  >> Restarted Apache  [\e[1;32mOK\e[1;37m]\e[0m"
}

function lamp-output {

        echo -e "\e[1;37m [+] LAMP Server Details \e[0m"
           lsb_release -a |  grep Description
           sudo dpkg -l apache2 | grep ii
           sudo dpkg -l mysql-server | grep ii
           php -version | grep PHP

}


function moodle-app  {

                    echo -e "\e[1;34m \n  Getting Moodle from GIT.
 #################################################################\e[0m\n" 

        # wget https://download.moodle.org/download.php/direct/stable36/moodle-latest-36.tgz -O ~/downloads/moodle-latest.tgz 
        # tar -xvzf moodle-latest.tgz 
        
        git clone -b MOODLE_311_STABLE https://github.com/moodle/moodle.git &>> debug.txt |echo -e "\e[1;37m [+] Downloading Moodle v3.11 from github. . . . .\e[0m"
        wdir=`pwd`
        # git branch -a
        # git checkout MOODLE_311_STABLE
       echo -e "  >> Moodle Download Complete  [\e[1;32mOK\e[1;37m]\e[0m"
        
        
        echo -e "\e[1;37m [+] Copying to /var/www . . . . .\e[0m"
        sudo cp -R $wdir/moodle /var/www/ 
        echo -e "  >> Copied  [\e[1;32mOK\e[1;37m]\e[0m"
        
        echo -e "\e[1;37m [+] Changing permission of copied folder . . . . .\e[0m"
        sudo chown -R www-data:www-data /var/www/moodle/
        sudo chmod -R 0755 /var/www/moodle/
        sudo find /var/www/moodle -type f -exec chmod 0644 {} \; 
        echo -e "  >> Changed permission [\e[1;32mOK\e[1;37m]\e[0m"
        

        sudo rm -Rf /var/www/html/
        echo -e "\e[1;37m [+] Updating default site folder to moodle . . . . .\e[0m"
        #Changing the moodle folder as defaut www folder
        sudo sed -i 's/html/moodle/g' /etc/apache2/sites-enabled/000-default.conf
        sudo service apache2 reload
        echo -e "  >> Updated default site folder to moodle  [\e[1;32mOK\e[1;37m]\e[0m"
        cat /etc/apache2/sites-enabled/000-default.conf | grep DocumentRoot 

        echo -e "\e[1;37m [+] Creating & changing permission moodledata folder . . . . .\e[0m"
        sudo mkdir /var/www/moodledata 
        sudo chmod 0777 /var/www/moodledata/
        sudo chown -R www-data:www-data /var/www/moodledata/
        echo -e "  >> Created & Changed permission [\e[1;32mOK\e[1;37m]\e[0m"
        
}

function output-moodle {
                    echo -e "\e[1;34m \n  Moodle hosting Link.
 #################################################################\e[0m\n" 

www=$(dig +short myip.opendns.com @resolver1.opendns.com) 
echo -e "\e[1;37m [+]  Visit  http://$www if you have enabled SSL Visit https://$www  
                                        [\e[1;32m Complete \e[1;37m]\e[0m"

} 

function input-ip {
    read -p "  Enter the IP address of the server GFS-Moo 1: " ip1
    read -p "  Enter the IP address of the server GFS-Moo 2: " ip2
    read -p "  Enter the IP address of the server GFS-Moo 3: " ip3
}

function ping-nodes {
            echo -e "\e[1;34m \n  Pinging the GFS-Moo Nodes to make sure they are up and running.
 #################################################################\e[0m" 
            echo -e "\e[1;37m [+] The IPs of the GFS-Moo Nodes are: $ip1, $ip2, $ip3"
            echo -e "\e[0m"


             ping -c 1 $ip1 1> /dev/null 2>&1
             if [ $? -eq 0 ]; then
                 echo -e "  >> GFS-Moo Node 1 - \e[1;37m $ip1 is reachable\e[0m"
             else
                echo -e "\e[1;31m  >> GFS-Moo Node 1 - $ip1 is not reachable"
                echo -e "\e[0m"
                exit 1
             fi
            ping -c 1 $ip2 1> /dev/null 2>&1
                 if [ $? -eq 0 ]; then     
                echo -e "  >> GFS-Moo Node 2 - \e[1;37m $ip2 is reachable\e[0m"
            else
                 echo -e "\e[1;31m  >> GFS-Moo Node 2 - $ip2 is not reachable"
                echo -e "\e[0m"
                exit 1
             fi

              ping -c 1 $ip3 1> /dev/null 2>&1
              if [ $? -eq 0 ]; then
                echo -e "  >> GFS-Moo Node 3 -\e[1;37m  $ip3 is reachable\e[0m"
             else
                echo -e "\e[1;31m  >> GFS-Moo Node 3 - $ip3 is not reachable"
                echo -e "\e[0m"
                exit 1
              fi
             
            

}


function select-glusterfs-server {
    echo -e "\e[1;34m \n  Please select your current HOST to be used for the GlusterFS cluster 
 #################################################################\e[0m" 
echo -e "\e[1;37m\n 1. GFS-Moo-01 \e[0m"
echo -e "\e[1;37m 2. GFS-Moo-02 \e[0m"
echo -e "\e[1;37m 3. GFS-Moo-03 \e[0m" 
echo -e "\e[1;32m"
read -p "  Enter your choice:" option
echo -e "\e[0m"
hostname="$(hostname)"

if [ $option == "1" ]
then
    echo -e "\e[1;37m  [+] You have selected \e[1;32m GFS-Moo-01\e[0m"
    hostnamectl set-hostname gfs-moo-01
    echo "127.0.0.1 $hostname" > /etc/hosts
    echo "$ip2  gfs-moo-02" >> /etc/hosts
    echo "$ip3  gfs-moo-03" >> /etc/hosts
    
else
    if [ $option == "2" ]
    then
        echo -e "\e[1;37m  [+] You have selected \e[1;32m GFS-Moo-02\e[0m"
        sudo hostnamectl set-hostname gfs-moo-02
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  gfs-moo-01" >> /etc/hosts
        echo "$ip3  gfs-moo-03" >> /etc/hosts
    else
        if [ $option == "3" ]
        then
        echo -e "\e[1;37m  [+] You have selected \e[1;32m GFS-Moo-03\e[0m"
        sudo hostnamectl set-hostname gfs-moo-03
        echo "127.0.0.1 $hostname" > /etc/hosts
        echo "$ip1  gfs-moo-01" >> /etc/hosts
        echo "$ip2  gfs-moo-02" >> /etc/hosts
        else
        echo -e "\e[1;31m  >> Your input is invalid - \e[1;32m $option \n\e[0m"
        exit 1
        fi
        
    fi
fi

 echo -e "\e[1;37m  [+] ip addresses written to /etc/hosts"
 host=$(hostname)
 echo -e "\e[1;37m  [+] Hostname written to /etc/hostname - you are on \e[1;32m $host \e[0m "
        echo -e "\e[0m"
}

function install-glusterfs {

        echo -e "\e[1;34m \n  Installing GlusterFS and Dependencies
#######################################\e[0m"
        echo -e "Sit back and relax installing all dependencies  \n\e[0m"

        sudo apt install software-properties-common -y &>> debug.txt | echo -e "\e[1;37m [+] Installing software-properties-common . . . . .\e[0m"
        echo -e "  >> Installed software-properties-common  [\e[1;32mOK\e[1;37m]\e[0m"

        sudo add-apt-repository ppa:gluster/glusterfs-7 -y &>> debug.txt | echo -e "\e[1;37m [+] Adding Gluster repository . . . . .\e[0m"
        echo -e "  >> GlusterFS repository (glusterfs-7) added [\e[1;32mOK\e[1;37m]\e[0m"

        sudo apt-get update -y &>> debug.txt | echo -e "\e[1;37m [+] updating . . . . .\e[0m"
        echo -e "  >> apt update [\e[1;32mOK\e[1;37m]\e[0m"

        sudo apt install glusterfs-server -y &>> debug.txt | echo -e "\e[1;37m [+] Installing GlusterFS server . . . . .\e[0m"
        echo -e "  >> GlusterFS Server installed [\e[1;32mOK\e[1;37m]\e[0m"

        sudo systemctl start glusterd &>> debug.txt | echo -e "\e[1;37m [+] Starting GlusterFS server . . . . .\e[0m"
        echo -e "  >> GlusterFS Server started [\e[1;32mOK\e[1;37m]\e[0m"

        sudo systemctl enable glusterd &>> debug.txt | echo -e "\e[1;37m [+] Enabling GlusterFS server . . . . .\e[0m"
        echo -e "  >> GlusterFS Server enabled [\e[1;32mOK\e[1;37m]\e[0m"

        mkdir -p /glusterfs
        echo -e "\e[1;37m [+] /glusterfs folder Created [\e[1;32mOK\e[1;37m]\e[0m"


}


function probe-glusterfs {
        echo -e "\e[1;34m \n  Probing GFS-Moo Nodes
#######################################\e[0m"

        if [ "$host" == "gfs-moo-01" ] ;
        then
            echo -e "\e[1;37m\n  [+] Setting GFS-Moo-01 as the Master node\e[0m"
            echo -e "\e[1;37m  [+] Probing GFS-Moo-02\e[0m" && gluster peer probe gfs-moo-02 
            echo -e "\e[1;37m  [+] Probing GFS-Moo-03\e[0m" && gluster peer probe gfs-moo-03 
            echo -e "\e[1;37m  [+] Creating GlusterFS volume gv0\e[0m" && sudo gluster volume create gv0 replica 3 transport tcp gfs-moo-01:/glusterfs gfs-moo-02:/glusterfs gfs-moo-03:/glusterfs force
            echo -e "\e[1;37m  [+] Starting GlusterFS volume gv0\e[0m" && sudo gluster volume start gv0
            echo -e "\e[1;37m  [+]  GlusterFS volume info\e[0m" && sudo gluster volume info

         else
          echo -e "\e[1;37m  [-] This is not GFS-Moo-01 , Script is running on $host so skipping Master Node Setup \e[0m "
         fi
 
        
}

function gfs-output {

echo -e "\e[1;32m\n  ***Instalation Complete****\e[0m\n"
}


echo -e "\e[1;32m"

echo "
 ######   ########  ######          ##     ##  #######   #######  
##    ##  ##       ##    ##         ###   ### ##     ## ##     ## 
##        ##       ##               #### #### ##     ## ##     ## 
##   #### ######    ######  ####### ## ### ## ##     ## ##     ## 
##    ##  ##             ##         ##     ## ##     ## ##     ## 
##    ##  ##       ##    ##         ##     ## ##     ## ##     ## 
 ######   ##        ######          ##     ##  #######   #######

################################################################
Script to launch GlusterFS, LAMp Server, Moodle on linux servers
                                Author:  Anuvindh - iCTPro.io
                                Version: 0.0.1 
################################################################
Check list before you go to next steps :-

* Launch three ec2 instance with Ubuntu OS
* The Public IP of EC2 Instances (Assign Elastic IP for production)
* Make sure your Security groups have ports opened as shown below
    22,24007,111,49152-49251,2049 for GlusterFS
    80,443 for Apache/Moodle
    22 for SSH"

echo -e "\e[1;34m \n  Please select your choice for GFS-Moo
 #################################################################\e[0m" 
echo -e "\e[1;37m\n 1. Install LAMP Server \e[0m"
echo -e "\e[1;37m 2. Install Moodle (select only if Apache2 already installed ) \e[0m"
echo -e "\e[1;37m 3. Install LAMP Server + Moodle \e[0m" 
echo -e "\e[1;37m 4. Install GlusterFS \e[0m"
echo -e "\e[1;37m 5. Install GlusterFS + LAMP Server + Moodle \e[0m"
echo -e "\e[1;32m"
read -p "Enter your choice:" option
echo -e "\e[0m"

# update-ubuntu
# lamp-server
# moodle-app 
# output-moodle
# input-ip
# ping-nodes
# select-glusterfs-server
# install-glusterfs
# probe-glusterfs
# gfs-output
# lamp-output

if [ $option == "1" ]
then
    echo -e "\e[1;37m  [+] You have selected \e[1;32m Install LAMP Server \e[0m\n"
    update-ubuntu
    lamp-server
    lamp-output
    else
    if [ $option == "2" ]
    then
        echo -e "\e[1;37m  [+] You have selected \e[1;32m Install Moodle (select only if Apache2 already installed )\e[0m\n"
        update-ubuntu
        moodle-app
        output-moodle
        else
         if [ $option == "3" ]
         then
         echo -e "\e[1;37m  [+] You have selected \e[1;32m Install LAMP Server + Moodle\e[0m\n"
        update-ubuntu
        lamp-server
        moodle-app
        lamp-output
        output-moodle
        
         else
         if [ $option == "4" ]
         then
         echo -e "\e[1;37m  [+] You have selected \e[1;32m Install GlusterFS\e[0m \n"
            input-ip
            ping-nodes
            update-ubuntu
            select-glusterfs-server
            install-glusterfs
            probe-glusterfs
            gfs-output

         else
         if [ $option == "5" ]
         then
         echo -e "\e[1;37m  [+] You have selected \e[1;32m Install GlusterFS + LAMP Server + Moodle \e[0m\n"
            input-ip
            ping-nodes
            update-ubuntu
            lamp-server
            moodle-app
            lamp-output
            output-moodle
            select-glusterfs-server
            install-glusterfs
            probe-glusterfs
            gfs-output
         else
         echo -e "\e[1;31m  >> Your input is invalid - \e[1;32m $option  - exiting \n\e[0m"
        exit 1
        fi
        fi
        fi
        fi
        fi


