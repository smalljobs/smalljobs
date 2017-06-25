# Small Jobs

This is the repo for smalljobs.ch.

## Development

* [Pivotal Tracker](https://www.pivotaltracker.com/s/projects/789611) for managing requirements and bug tracking.
* [GitHub](https://github.com/ratte/smalljobs) for source code management.
* [Heroku](https://dashboard.heroku.com/apps/smalljobs/resources) for production hosting.

### Running locally

Make sure [Ruby 2](https://www.ruby-lang.org/en/) and [Bundler](http://bundler.io/) are installed. Also PostgreSQL
should be accessible with the user `smalljobs` without password.


#### Clone the repo

Get the source by cloning the repo:

```bash
$ git clone git@github.com:ratte/smalljobs.git
$ cd smalljobs
```

#### Prepare the database

Get the database ready and populate with needed data:

```bash
$ rake db:setup
```

Alternatively you can sync the production database to your local database:

```bash
$ heroku pg:pull DATABASE_URL smalljobs_development
```

#### Start the server

Start the local [unicorn](http://unicorn.bogomips.org/) server

```bash
$ RAILS_ENV=development bundle exec unicorn -p 3000 -c config/unicorn.rb
```

and open [the site](http://dev.smalljobs.ch:3000/) or the [admin interface](http://dev.smalljobs.ch:3000/admin).


#### Update to latest version

You can update your local project with:

```bash
$ cd smalljobs
$ git pull origin master
$ rake db:migrate
```

#### Vagrant Box

If you want to test the Application in a proper environment, use Vagrant/Virtualbox for testing:

```bash
$ vagrant up
$ ssh vagrant
$ cd /vagrant
```
Handling of [vagrant-Box](/puppet/README.md)

#### Local SMPT Server

If you want to preview the app emails, you need to install [MailCatcher](http://mailcatcher.me/) with:

```bash
$ gem install mailcatcher
```

and then start the local SMTP server **before** starting the Rails app server with:

```bah
$ mailcatcher
```

Now you can browser the sent email by opening [http://localhost:1080](http://localhost:1080) in your browser.

#### Testing

SmallJobs is testes extensively, so make sure you do not break the specs before pushing to master.

```bash
$ rake spec
```

You may want to enable continous testing by running Guard:

```bash
$ bundle exec guard
```

## Configuration

This application uses several third-party services. All access keys and passwords are stored as a environmental variables.
These services are:
* S3 storage on Amazon AWS - used to store some images by Rich and Carrierwave gems. You can read about configuring it here: https://github.com/kreativgebiet/rich#uploading-to-s3 and here: https://github.com/carrierwaveuploader/carrierwave#using-amazon-s3
* Sendgrid - as smtp server. You should provide SENDGRID_USERNAME and SENDGRID_PASSWORD.
* Devise - used for authentication. Secret key and pepper are stored as DEVISE_SECRET and DEVISE_PEPPER
* Scout - for monitoring. Scout APM key is stored as SCOUT_KEY.