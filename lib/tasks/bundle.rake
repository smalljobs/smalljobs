namespace :bundle do
  task install: :environment do
    exec("bundle install")
  end
end
