namespace :bundle do
  task install: :environment do
    begin
      exec("RAILS_ENV=staging bundle install")
      logger.info "bundle install VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO bundle install VIA RAKE TASK!!!!!"
    end
  end
end
