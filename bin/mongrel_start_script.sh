#! /bin/sh
# /etc/init.d/pentabarf-announcer
#


# Carry out specific functions when asked to by the system
case "$1" in
  start)
    echo "Starting pentabarf-announcer mongrels"
    /usr/bin/ruby /usr/bin/mongrel_rails cluster::start -C /home/announcer/app/current/config/mongrel_cluster.yml
    ;;
  stop)
    echo "Stopping pentabarf-announcer mongrels"
    /usr/bin/ruby /usr/bin/mongrel_rails cluster::stop -C /home/announcer/app/current/config/mongrel_cluster.yml
    ;;
  *)
    echo "Usage: /etc/init.d/pentabarf-announcer {start|stop}"
    exit 1
    ;;
esac

exit 0