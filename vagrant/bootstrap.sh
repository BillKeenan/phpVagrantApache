#!/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
sudo echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

sudo apt-get update
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update

sudo apt-get install -y apache2
sudo apt-get install -y php5
sudo apt-get install -y php5-dev
sudo apt-get install -y php5-cli
sudo apt-get install -y php5-pear
sudo apt-get install -y curl
sudo apt-get install -y git
sudo apt-get install -y php5-curl
sudo service mongod start

sudo apt-get install -y php-pear

sudo rm /etc/apache2/sites-enabled/*
sudo cp /data/web/vagrant/wagon.conf /etc/apache2/sites-enabled/
sudo apachectl stop

sudo rm -rf /var/lock/apache2
sudo sed -i 's/www-data/vagrant/g' /etc/apache2/envvars

cd /tmp
curl -sS https://getcomposer.org/installer | php  -- --check.
sudo mv composer.phar /usr/local/bin/composer

sudo apachectl start
cd /data/web/wagon/
composer update
composer install

sudo chown -R vagrant /data/web/wagon/app


php app/console cache:clear --env=prod
php app/console cache:clear --env=dev

sudo chown -R vagrant /data/web/wagon/app

echo "run 'vagrant gatling-rsync-auto' on the host machine to auto-sync"
echo "load http://localhost:9000/app_dev.php to get started"