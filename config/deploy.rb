require 'rexml/document' #gem install rexml 

# This defines a deployment "recipe" that you can feed to capistrano
# (http://manuals.rubyonrails.com/read/book/17). It allows you to automate
# (among other things) the deployment of your application.

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The deploy_to path must be the path on each machine that will
# form the root of the application path.

set :application, "revlogic"
set :base_repository, "https://secure.svnrepository.com/s_revenuem/revlogic/hlscworkalloc"
set :repository, "#{base_repository}/trunk" # default, but is overwritten by set_tag

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

# set :server, "125.17.225.115" # The interface for use from outside the firewall
# set :server, "uranus.rmed.com" # The standard interface for use within the firewall
set :server, "neptune.rmed.com" # The standard interface for use within the firewall
role :web, "#{server}", :primary => true
role :app, "#{server}", :primary => true
role :db, "#{server}", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :deploy_to, "/var/www/apps" # defaults to "/u/apps/#{application}"
# This could speed up deployment, but not sure how it would work with tagging.
# set :deploy_via, :remote_cache 
set :user, "revlogic"           # defaults to the currently logged in user
set :use_sudo, false
# set :scm, :darcs               # defaults to :subversion
# set :svn, "/path/to/svn"       # defaults to searching the PATH
# set :darcs, "/path/to/darcs"   # defaults to searching the PATH
# set :cvs, "/path/to/cvs"       # defaults to searching the PATH
# set :gateway, "gate.host.com"  # default to no gateway

# =============================================================================
# SSH OPTIONS
# =============================================================================
# ssh_options[:port] = 29 # Set for use outside the firewall
ssh_options[:username] = 'revlogic'

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

# Tasks may take advantage of several different helper methods to interact
# with the remote server(s). These are:
#
# * run(command, options={}, &block): execute the given command on all servers
#   associated with the current task, in parallel. The block, if given, should
#   accept three parameters: the communication channel, a symbol identifying the
#   type of stream (:err or :out), and the data. The block is invoked for all
#   output from the command, allowing you to inspect output and act
#   accordingly.
# * sudo(command, options={}, &block): same as run, but it executes the command
#   via sudo.
# * delete(path, options={}): deletes the given file or directory from all
#   associated servers. If :recursive => true is given in the options, the
#   delete uses "rm -rf" instead of "rm -f".
# * put(buffer, path, options={}): creates or overwrites a file at "path" on
#   all associated servers, populating it with the contents of "buffer". You
#   can specify :mode as an integer value, which will be used to set the mode
#   on the file.
# * render(template, options={}) or render(options={}): renders the given
#   template and returns a string. Alternatively, if the :template key is given,
#   it will be treated as the contents of the template to render. Any other keys
#   are treated as local variables, which are made available to the (ERb)
#   template.

# You can use "transaction" to indicate that if any of the tasks within it fail,
# all should be rolled back (for each task that specifies an on_rollback
# handler).

namespace :deploy do
  namespace :monit do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} mongrel using monit" 
      task t, :roles => :app do
        invoke_command "monit -g mongrel #{t.to_s} all", :via => run_method
      end
    end
  end
  desc "restart mongrel using monit" 
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.monit.restart
  end
  desc "start mongrel using monit" 
  task :start, :roles => :app do
    deploy.monit.start
  end
  desc "stop mongrel using monit" 
  task :stop, :roles => :app do
    deploy.monit.stop
  end

  # task :set_tag do
  #   # get the release path
  #   depend :local, :command, "svn"
  # 
  #   show_recent_tags("#{base_repository}/tags")
  #   tag = ::Capistrano::CLI.ui.ask("which tag (blank for trunk): ")
  #   if tag == ""
  #     new_tag = ::Capistrano::CLI.ui.ask("deploy from trunk, but you have to give it a tag: ")
  #     raise Capistrano::Error, "have to tag a new release" if new_tag == ""
  #     #raise error if there are invalid characters
  # 
  #     raise Capistrano::Error, "invalid characters in tag" if new_tag =~ /[|]|\?|:|\/|\*|\"|\'||\||(\s)/ 
  #     cmd = "svn copy quiet message \"cap tagged release\" #{base_repository}/trunk #{base_repository}/tags/#{new_tag}"
  #     puts  "  * locally executing \"#{cmd}\""
  #     system cmd
  #     tag = new_tag
  #   end
  # 
  #   set :repository, "#{base_repository}/tags/#{tag}"
  #   puts "repository: #{repository}"
  # end
  # 
  # # Overwrite update_code task to add call to set_tag
  # desc "Copies your project to the remote servers."
  # task :update_code, :except => { :no_release => true } do
  # 
  #   set_tag
  #   on_rollback { run "rm -rf #{release_path}; true" }
  #   strategy.deploy!
  #   finalize_update
  # end
  # 
  # def show_recent_tags(repo)
  # 
  #   hsh = Hash.new
  #   cmd = "svn ls --xml #{repo}"
  #   puts " >> Listing tags: "
  #   pipe = IO.popen cmd
  #   result = pipe.read
  # 
  #   pipe.close
  #   entries = REXML::Document.new(result).root.elements['list']
  #   entries.elements.each do |e|
  #     # set hash key to release id and value to: name by: commit.author
  #     hsh[e.elements['commit'].attribute('revision').to_s] = e.elements['name'].text + " \tby: " + e.elements['commit'].elements['author'].text
  #   end
  # 
  #   sorted_arr = hsh.sort {|a,b| a[0].to_i <=> b[0].to_i}
  #   if sorted_arr.size > 5
  #     sorted_arr.to_a[-5, 5].each {|t| puts "#{t[1]} \trev: #{t[0]} "}
  #   else
  #     sorted_arr.to_a.each {|t| puts "#{t[1]} \trev: #{t[0]} "}
  # 
  #   end
  # end
end

require 'erb'

before "deploy:setup", :db
after "deploy:update_code", "db:symlink" 

namespace :db do
  desc "Create database yaml in shared path" 
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      socket: /var/run/mysqld/mysqld.sock
      username: #{user}
      password: #{password}

    development:
      database: #{application}_dev
      <<: *base

    test:
      database: #{application}_test
      <<: *base

    production:
      database: #{application}_prod
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml" 
  end

  desc "Make symlink for database yaml" 
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end