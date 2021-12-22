

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