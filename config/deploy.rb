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
set :use_sudo, false
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"

role :web, "saal1.local"#, "saal2.local", "saal3.local"
role :app, "saal1.local"#, "saal2.local", "saal3.local"
role :db, "saal1.local", :primary=>true #, "saal2.local", "saal3.local"

namespace :deploy do
  desc "Link all additional required directories and files"
  task :after_symlink do
    run "cp #{current_release}/config/database.yml.example #{current_release}/config/database.yml"
    run "cp #{current_release}/config/mongrel_cluster.yml.example #{current_release}/config/mongrel_cluster.yml"
    run "ln -s #{deploy_to}/shared/db/production.sqlite3 #{current_release}/db/production.sqlite3"
  end    
  
  task :after_setup do
    run "mkdir -p #{deploy_to}/shared/db"
  end
  
#  task :after_symlink do

#  end
  
 # task :restart do
 #   restart_mongrel_cluster
 # end
end

namespace :congress do
  desc "Updated pentabarf from the internet"
  task :update_data do
    run %Q{cd #{current_release} && ruby script/runner -e production 'Event.import_from_pentabarf_url("http://events.ccc.de/congress/2009/Fahrplan/schedule.en.xml")'}
  end
end