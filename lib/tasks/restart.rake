namespace :restart do
  desc "TODO"
  task passenger: :environment do
    exec("touch tmp/restart.txt")
  end

  task nginx_with_env: :environment do
    exec("echo \"rails_env production;\" >  /etc/nginx/ruby.env")
    exec("sudo /etc/init.d/nginx restart")
  end

end
