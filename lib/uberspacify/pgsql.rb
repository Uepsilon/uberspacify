Capistrano::Configuration.instance.load do

  # callbacks
  after   'deploy:setup',       'pgsql:setup_database_and_config'

  # custom recipes
  namespace :pgsql do
    task :setup_database_and_config do
      # Read the Config for the Project
      pgcfg = capture('cat ~/.pgsql.cnf')
      config = {}
      %w(development production test).each do |env|

        config[env] = {
          'adapter'   => 'postgresql',
          'encoding'  => 'utf8',
          'host'      => 'localhost',
        }

        pgcfg.match(/#{fetch :application}:(\w+):(\w+):(\w+)\n/)
        config[env]['username'] = $1
        config[env]['password'] = $2
        config[env]['database'] = $3
      end

      run "mkdir -p #{fetch :shared_path}/config"
      put config.to_yaml, "#{fetch :shared_path}/config/database.yml"

    end
  end

end
