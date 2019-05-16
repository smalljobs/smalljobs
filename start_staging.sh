cd /var/www/webroot/ROOT/
RAILS_ENV=production bundle exec rake set:rails_env_prod
RAILS_ENV=production bundle exec rake restart:nginx
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake assets:precompile
touch tmp/restart.txt