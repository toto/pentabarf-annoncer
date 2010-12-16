require 'mongrel_cluster/recipes'
set :application, "pentabarf-announcer"
set :repository,  "git://github.com/toto/pentabarf-annoncer.git"

# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

#load 'ext/rails-database-migrations.rb'
#load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/announcer/app"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :user, 'announcer'
set :runner, 'announcer'
#set :use_sudo, false
default_run_options[:pty] = true
#set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"

hosts = ENV['HOSTS'].split(' ') unless ENV['HOSTS'].nil? || ENV['HOSTS'].empty?
#hosts ||= %w{26c3saal1.dyndns.org 26c3saal2.dyndns.org 26c3saal3.dyndns.org}
hosts ||= %w{saal1.local saal2.local saal3.local}


role :web, *hosts
role :app, *hosts
role :db,  *hosts << {:primary=>true})

# Bluepill related tasks
after "deploy:update", "deploy:restart"
namespace :deploy do
  desc "Restart Unicorn"
  task :restart, :roles => [:app] do
    sudo "/etc/init.d/unicorn restart"
  end
 
  desc "Start Unicorn"
  task :start, :roles => [:app] do
    sudo "/etc/init.d/unicorn start"
  end

  desc "Stop Unicorn"
  task :stop, :roles => [:app] do
    sudo "/etc/init.d/unicorn stop"
  end
end

after "deploy:symlink", "announcer:additional_symlinks"
after "deploy:setup", "announcer:additional_setup"
namespace :announcer do
  
  desc "Link all additional required directories and files"
  task :additional_symlinks do
    run "cp #{current_release}/config/database.yml.example #{current_release}/config/database.yml"
  #  run "cp #{current_release}/config/mongrel_cluster.yml.example #{current_release}/config/mongrel_cluster.yml"
    run "ln -s #{deploy_to}/shared/db/production.sqlite3 #{current_release}/db/production.sqlite3"
  end    
  
  task :additional_setup do
    run "mkdir -p #{deploy_to}/shared/db"
  end  
end

namespace :congress do
  desc "Updated pentabarf from the internet"
  task :update_data do
    # note that Event.import_from_pentabarf_url also works perfectly with a file path    
    run %Q{cd #{current_release} && ruby script/runner -e production 'Event.import_from_pentabarf_url("http://events.ccc.de/congress/2010/Fahrplan/schedule.en.xml")'}
  end
  
  desc "Force reload of pentabarf from the internet"
  task :force_update_data do
    # note that Event.import_from_pentabarf_url also works perfectly with a file path    
    run %Q{cd #{current_release} && ruby script/runner -e production 'Event.delete_all; Event.import_from_pentabarf_url("http://events.ccc.de/congress/2010/Fahrplan/schedule.en.xml")'}
  end  
  
  desc "delets all events"
  task :delete_events do
    run %Q{cd #{current_release} && ruby script/runner -e production 'Event.delete_all'}
  end  
  
  desc "make it seem the congress starts today"
  task :make_some_events_current do
    run %Q{cd #{current_release} && ruby script/runner -e production 'Event.make_some_events_current'}
  end
end