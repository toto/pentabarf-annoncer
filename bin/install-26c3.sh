#!/bin/sh
export DESTINATION="/home/announcer"
export UNSTABLE="deb http://http.us.debian.org/debian unstable main contrib non-free"
echo $UNSTABLE | cat - >> /etc/apt/sources.list
aptitude update 
aptitude safe-upgrade -y
aptitude install build-essential openssh-server git-core ruby1.8 sudo rsync rubygems1.8 mongrel sqlite3 rake  vim ssh xorg gdm nginx libsqlite3-ruby1.8 libopenssl-ruby1.8 ruby1.8-dev libnokogiri-ruby1.8 avahi-daemon  mongrel-cluster irb1.8 -y
# aptitude install --with-recommends bastille
aptitude install --with-recommends epiphany-webkit arora


gem install rails --no-ri --no-rdoc -v=2.3.4
gem install will_paginate
mkdir -p $DESTINATION/.ssh
chmod -R o-rwx $DESTINATION/.ssh
chmod -R g-w $DESTINATION/.ssh
export SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAxG4eu4c7vt9nfzW475+clZseDQAZ8EOvPYP10XahkFlFxyxdw4rwKUqDk4v9YqsOEd71/9XdZbebVQwz4qRvN0VoWdtER9gHHEALGMzfEL7iavcqTECg4d9NKqNKyfu67RDCvdDdUrAoTFFi0UQe5LBa3NxL9jQDHz6HecdmN80= toto@amber.lan"
echo $SSH_KEY | cat - > $DESTINATION/.ssh/authorized_keys2
git clone git://github.com/toto/pentabarf-annoncer.git $DESTINATION/pentabarf-annoncer
cd $DESTINATION/pentabarf-annoncer && git pull

cp $DESTINATION/pentabarf-annoncer/config/database.yml{.example,}
cd $DESTINATION/pentabarf-annoncer && rake gems:install
cd $DESTINATION/pentabarf-annoncer && rake db:create:all


chown -R announcer $DESTINATION

# create user
useradd -m -s /bin/bash -p `mkpasswd www SD` www
export XSESSION = "exec arora -geometry 1024x768+0+0"
echo $XSESSION | cat - >/home/www/.Xsession
mkdir -p /home/www/.config/arora-browser.org/

export ARORA_CONFIG=/home/www/.config/arora-browser.org/Arora.conf
echo "[MainWindow]" | cat - > $ARORA_CONFIG
echo "home=http://localhost:3000/rooms/2/events" | cat - >> $ARORA_CONFIG
echo "" | cat - >> $ARORA_CONFIG

chown -R www:www /home/www
# add announcer to the sudo group
adduser announcer sudo

# enable services 
update-rc.d avahi-daemon enable
update-rc.d nginx enable

mkdir -p /etc/mongrel_cluster/
cp $DESTINATION/pentabarf-annoncer/config

sleep 2		

# http://wiki.debian.org/NvidiaGraphicsDrivers#non-freedrivers	
#export VERSION="-legacy-96xx"
	

# files: 
# /etc/X11/xorg.conf
# 
# 
# /etc/console-tools/config
# Set: BLANK_TIME=0
# Set: POWERDOWN_TIME=0
# gdm.conf
# [daemon]
# TimedLoginEnable=true
# TimedLogin=www
# TimedLoginDelay=0

