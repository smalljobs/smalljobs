#!/bin/bash
RAILS_ENV=development bundle exec unicorn -p 3000 -c config/unicorn.rb