set -e
echo 'Running a one-time configuration script'

echo 'Creating a database if it does not exist'
echo "passwordhosting" | sudo -S su postgres -c /tmp/postgres_script.sh
echo 'Database was created'

echo 'Checking if the project is downloaded'
if [ ! -d /home/hosting/workspace/smalljobs  ]; then
    echo 'zasysam projekt'
    cd /home/hosting/workspace && git clone git@github.com:smalljobs/smalljobs.git
fi
echo 'The project is located in /home/hosting/workspace'

echo 'Gems installation'
cd /home/hosting/workspace/smalljobs && bundle install
echo 'Gems installed'


echo 'Launch of yarna'
cd /home/hosting/workspace/smalljobs && yarn
echo 'Noda libraries were installed'

echo 'Start migatrion'
cd /home/hosting/workspace/smalljobs && bundle exec rake db:migrate
echo 'End migration'

echo 'Removing one-time scripts'

rm /tmp/postgres_script.sh
rm /tmp/self_destruct_script.sh
