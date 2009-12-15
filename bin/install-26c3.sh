#!/bin/sh
export DESTINATION="/home/announcer"
export UNSTABLE="deb http://http.us.debian.org/debian unstable main contrib non-free"
echo $UNSTABLE | cat - >> /etc/apt/sources.list
aptitude update 
aptitude safe-upgrade -y
aptitude install build-essential openssh-server git-core ruby1.8 sudo rsync rubygems1.8 mongrel sqlite3 rake  vim ssh xorg gdm nginx libsqlite33-ruby1.8 libopenssl-ruby1.8 ruby1.8-dev libnokogiri-ruby1.8 
# aptitude install --with-recommends bastille
aptitude install --with-recommends epiphany-webkit arora


gem install rails --no-ri --no-rdoc -v=2.3.4
mkdir -p $DESTINATION/.ssh
chmod -R o-rwx $DESTINATION/.ssh
chmod -R g-w $DESTINATION/.ssh
export SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAxG4eu4c7vt9nfzW475+clZseDQAZ8EOvPYP10XahkFlFxyxdw4rwKUqDk4v9YqsOEd71/9XdZbebVQwz4qRvN0VoWdtER9gHHEALGMzfEL7iavcqTECg4d9NKqNKyfu67RDCvdDdUrAoTFFi0UQe5LBa3NxL9jQDHz6HecdmN80= toto@amber.lan"
echo $SSH_KEY | cat - > $DESTINATION/.ssh/autorized_keys2
git clone git://github.com/toto/pentabarf-annoncer.git $DESTINATION/pentabarf-annoncer

cp $DESTINATION/pentabarf-annoncer/config/database.yml{.example,}
cd $DESTINATION/pentabarf-annoncer && rake gems:install
cd $DESTINATION/pentabarf-annoncer && rake db:create:all

chown -R announcer $DESTINATION

# create user
useradd -m -s /bin/bash -p `mkpasswd www SD` www
sleep 2		
	
	
	