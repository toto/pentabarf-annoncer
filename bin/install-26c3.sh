#!/bin/sh
aptitude install build-essential openssh-server git-core ruby1.8 sudo rsync rubygems1.8 mongrel sqlite3 rake
mkdir ~/.ssh
chmod -R o-rwx ~/.ssh
chmod -R g-w ~/.ssh
SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAxG4eu4c7vt9nfzW475+clZseDQAZ8EOvPYP10XahkFlFxyxdw4rwKUqDk4v9YqsOEd71/9XdZbebVQwz4qRvN0VoWdtER9gHHEALGMzfEL7iavcqTECg4d9NKqNKyfu67RDCvdDdUrAoTFFi0UQe5LBa3NxL9jQDHz6HecdmN80= toto@amber.lan"
echo $SSH_KEY | cat - > ~/.ssh/autorized_keys2
git clone git://github.com/toto/pentabarf-annoncer.git 

cp ~/pentabarf-annoncer/config/database.yml{.example,}
cd ~/pentabarf-annoncer && rake gems:install
cd ~/pentabarf-annoncer && rake db:create:all

chown -R announcer ~
