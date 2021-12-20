#!/bin/bash

echo -e "\e[1;34m \n          Welcome to the GlusterMood  
 #################################################################\e[0m" 
echo -e "\e[1;37m\n 1.GlusterFS with Three nodes \e[0m"
echo -e "\e[1;37m 2. GlusterFs + Moodle + LAMP Server  \e[0m" 
echo -e "\e[1;37m 3. Moodle + LAMP Server  \e[0m"
echo -e "\e[1;32m"
read -p "Enter your choice:" userinput
echo -e "\e[0m"

if [ $userinput == "1" ]
then
    echo -e "\e[1;37m  >> You have selected \e[1;32m $userinput\e[0m"
     assets/./glusterfs.sh
    
else
    if [ $userinput == "2" ]
    then
        echo -e "\e[1;37m  >> You have selected \e[1;32m $userinput\e[0m"
       
    else
        if [ $userinput == "3" ]
             then
        echo -e "\e[1;37m  >> You have selected \e[1;32m $userinput\e[0m"

        echo 
              else
        echo -e "\e[1;31m  >> Your inpur is invalid \e[1;32m $userinput \n\e[0m"
               exit 1
    
        fi
    fi
fi










