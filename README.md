# <img width="50" alt="portfolio_view" src=./assets/GFS-Moo.gif> GlusterFS for Moodle
------------
(Redundant Storage Pool Using GlusterFS on Ubuntu Servers for moodle)
![](./assets/gfsbanner.png)


![visitor badge](https://visitor-badge.glitch.me/badge?page_id=anuvindhs/GFS-Moo) ![Visitor Badge](https://visitor-badges.glitch.me?username=snuvindhs&repo=GFS-Moo) ![watchers](https://img.shields.io/github/watchers/anuvindhs/GFS-Moo) ![Licence](https://img.shields.io/github/license/anuvindhs/GFS-Moo) ![bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg) ![stars](https://img.shields.io/github/stars/anuvindhs/GFS-Moo) 

## Prerequisites 
------------
Launch three ubuntu based EC2 with enabled public IP (EIP recommended for production) & security groups with ports open as shown below. 

**Security Group** For GFS
|  Type | Protocol  | Ports  | Source |Description   |
| :------------: | :------------: | :------------: | :------------: |:------------: |
| SSH| SSH   | 22  | Administration Host Security Group   |Administration Host Security Group |
|  Custom TCP Rule  |  TCP | 2007  |  GlusterFS Security Group Secure Transport Server Security Group  | Gluster Daemon |
|  Custom TCP Rule  |TCP   | 111  | GlusterFS Security Group SecureTransport Server Security Group   | Portmapper |
| Custom TCP Rule   |TCP   | 49152-49251   |  GlusterFS Security Group SecureTransport Server Security Group  |Each brick for every volume on your host requires its own port  |
| Custom TCP Rule   | TCP  |  2049  | GlusterFS Security Group SecureTransport Server Security Group    | NFS |

**Security Group** For Moodle (LAMP)
|  Type | Protocol  | Ports  | Source |Description   |
| :------------: | :------------: | :------------: | :------------: |:------------: |
| HTTP |TCP | 80 | Users | For HTTP traffic|
|HTTPS |TCP| 443 | Users | For HTTPS traffic |

</br>

Here is **AWS CLI script** if you want to launch through CLI or use AWS Console 

 

```bash
 aws ec2 run-instances \ 
   --image-id ami-xxxxxxxxxxxxxx\ 
    --count 3 \ 
    --instance-type t2.micro \ 
    --key-name YourKey \ 
    --security-group-ids sg-xxxxxxxxxxxx \ 
    --subnet-id subnet-xxxxxxx \ 
    --associate-public-ip-address \ 
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=GlusterFS -}]' 
```
    
</br>

Use Putty to SSH into all three Servers, [Configure putty](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html)
If you want to use muti-SSH try [mRemoteNG](https://mremoteng.org/) (recommended) 
Also Note down the Public IP for all three servers, for the easy of understanding 

Let's Re-name  Servers on Console

|  Server   | Rename to   | Public IP   |
| :------------: | :------------: | :------------: |
|Server 1    | GlusterFS-01  |ip1 (use your server1 public IP) |
|Server 2 | GlusterFS-02  |ip2 (use your server2 public IP) |
|Server 3 | GlusterFS-03  |ip3 (use your server3 public IP) |


## Tutorial
------------
#### Blog
#### Youtube

## Basic Installation
------------
SSH into Servers orderly and run commands


Get root privilages to run command 
```bash
sudo su -
```

|  Stage | On Server | Command   |
| :------------: | :------------: |:------------ |
|  1 | **GlusterFS-03** |`wget https://raw.githubusercontent.com/anuvindhs/GFS-Moo/main/install.sh ` </br> `chmod u+x install.sh ` </br> `./instal.sh`|
|  2 |**GlusterFS-02** |`wget https://raw.githubusercontent.com/anuvindhs/GFS-Moo/main/install.sh ` </br> `chmod u+x install.sh ` </br> `./instal.sh`|
| 3 | **GlusterFS-01** |`wget https://raw.githubusercontent.com/anuvindhs/GFS-Moo/main/install.sh ` </br> `chmod u+x install.sh ` </br> `./instal.sh`|

[Inspect install.sh Code](https://github.com/anuvindhs/GFS-Moo/blob/main/install.sh) 
#### Mount Folder

```bash
sudo mount -t glusterfs gfs-moo-01:/gv0 /var/www/moodledata
```

## License
------------
Released under the [MIT license](LICENSE.txt).

