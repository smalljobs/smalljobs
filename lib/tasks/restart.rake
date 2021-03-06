namespace :restart do
  task passenger: :environment do
    begin
      exec("touch /var/www/webroot/ROOT/tmp/restart.txt")
      logger.info "touch tmp/restart.txt VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO bundle install VIA RAKE TASK!!!!!"
    end
  end

  task nginx: :environment do
    begin
      exec("sudo /etc/init.d/nginx restart")
      logger.info "restart_ngnix VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO restart_ngnix VIA RAKE TASK!!!!!"
    end
  end

end
