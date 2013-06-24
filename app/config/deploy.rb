default_run_options[:pty] = true

set :application, "sid"
set :domain,      "your-domain.com"
set :deploy_to,   "/path/to/deploy"
set :app_path,    "app"

set :user,        "username"
ssh_options[:forward_agent] = true
set :use_sudo, false

set :repository,  "git@your-domain.com:sid.git"
set :scm,         :git
set :branch,      "master"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `subversion`, `mercurial`, `perforce`, or `none`

set :model_manager, "doctrine"
# Or: `propel`

role :web,        domain                         # Your HTTP server, Apache/etc
role :app,        domain, :primary => true       # This may be the same as your `Web` server
role :db,         domain, :primary => true       # This is where Symfony2 migrations will run

set  :keep_releases,  1

# Be more verbose by uncommenting the following line
# logger.level = Logger::MAX_LEVEL

logger.level = Logger::MAX_LEVEL

set :writable_dirs, [app_path + "/cache", app_path + "/logs"]
set :webserver_user, "www-data"
set :permission_method, :acl
before "deploy:restart", "deploy:set_permissions"

set :use_composer, true
set :update_vendors, true

set :shared_files, ["app/config/parameters.yml"]
set :shared_children, [web_path + "/uploads", app_path + "/var"]
set :writable_shared_dirs, [web_path + "/uploads", app_path + "/var"]

before "symfony:cache:warmup", "symfony:doctrine:migrations:migrate"

before "symfony:cache:warmup", "deploy:assetic_dump"

namespace :deploy do
    task :assetic_dump do
        run "php #{latest_release}/app/console assetic:dump --env=prod"
    end
end

set :dev_only_files,    [web_path + "/app_dev.php", web_path + "/check.php", web_path + "/config.php"]
set :production, true
 
after 'symfony:cache:warmup', 'pff:productify'
 
namespace :pff do
    desc "Remove app_dev.php, check.php and config.php from production deployment"
    task :productify, :except => { :production => false } do
        if dev_only_files
            dev_only_files.map do |dev_file|
                run "rm -f #{latest_release}/#{dev_file}"
            end
        end
    end
end

after 'deploy:setup', 'sid:set_shared_folders_permissions'
# This function is a copy of the set_permissions function to handle shared children's writable permissions
namespace :sid do
    task :set_shared_folders_permissions, :roles => :app, :except => { :no_release => true } do
        if writable_shared_dirs && permission_method
            dirs = []
        writable_shared_dirs.each do |link|
            if shared_children && shared_children.include?(link)
                absolute_link = shared_path + "/" + link
            else
                absolute_link = latest_release + "/" + link
            end
            dirs << absolute_link
        end
        methods = {
            :chmod => [
                "chmod +a \"#{user} allow delete,write,append,file_inherit,directory_inherit\" %s",
                "chmod +a \"#{webserver_user} allow delete,write,append,file_inherit,directory_inherit\" %s"
            ],
            :acl   => [
                "setfacl -R -m u:#{user}:rwX -m u:#{webserver_user}:rwX %s",
                "setfacl -dR -m u:#{user}:rwx -m u:#{webserver_user}:rwx %s"
            ],
            :chown => ["chown #{webserver_user} %s"]
        }
        if methods[permission_method]
            capifony_pretty_print "--> Setting permissions"
            if fetch(:use_sudo, false)
                methods[permission_method].each do |cmd|
                    sudo sprintf(cmd, dirs.join(' '))
                end
            elsif permission_method == :chown
                puts "    You can't use chown method without sudoing"
            else
                dirs.each do |dir|
                    is_owner = (capture "`echo stat #{dir} -c %U`").chomp == user
                    if is_owner && permission_method != :chown
                        methods[permission_method].each do |cmd|
                            try_sudo sprintf(cmd, dir)
                        end
                    else
                        puts "    #{dir} is not owned by #{user} or you are using 'chown' method without ':use_sudo'"
                    end
                end
            end
            capifony_puts_ok
        else
            puts "    Permission method '#{permission_method}' does not exist.".yellow
        end
    end
end