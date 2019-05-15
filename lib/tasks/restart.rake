namespace :restart do
  desc "TODO"
  task passenger: :environment do
    begin
      exec("touch tmp/restart.txt")
      logger.info "touch tmp/restart.txt VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO bundle install VIA RAKE TASK!!!!!"
    end

  end

  task nginx_with_env: :environment do
    begin
      exec("echo \"rails_env production;\" >  /etc/nginx/ruby.env")
      exec("sudo /etc/init.d/nginx restart")
      logger.info "nginx_with_env VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO nginx_with_env VIA RAKE TASK!!!!!"
    end
  end

end
