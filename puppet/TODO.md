### Todo:

      

* write manifest for smalljobs:
  * initial: execute bundle install in /vagrant
  * initial: execute rake db:setup 
* add development/production switch to config from /config/database.yml
      
      


#### Done

  * 15.12.13 used dev-rails-box as source (http://github.com/rails/rails-dev-box).
      stripped mysql,memcache, nodejs
  * 15.12.13 added localhost settings for postgresql, 
  * 16.12.13 added 'git, htop, mc, vim, tmux'
  * 17.12.13 ```ERROR:  new encoding (UTF8) is incompatible with the encoding of the template database (SQL_ASCII)``` on ```rake db:create``` => postgresql encoding problems in ubuntu server
    * workaround 1) setting 'template:template0' in /config/database.yml works, but is not proper
    * [proper way](http://journal.tianhao.info/2010/12/postgresql-change-default-encoding-of-new-databases-to-utf-8-optional/) convert postgresql db-template from US_ASCII to UTF8:
      ```SQL
UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
\c template1
VACUUM FREEZE;
UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template1';
```
      
    

  * test if postresql is reload after login/role creation.
    
