namespace :set do
  task rails_env_prod: :environment do
    begin
      exec("echo \"rails_env staging;\" >  /etc/nginx/ruby.env")
      logger.info "rails_env_prod VIA RAKE TASK COMPLETED"
    rescue
      logger.error "FAILED TO rails_env_prod VIA RAKE TASK!!!!!"
    end
  end
end
