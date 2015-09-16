#!/bin/bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
sudo echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | sudo tee -a /etc/apt/sources.list.d/10gen.list
sudo wget -P /tmp https://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i /tmp/puppetlabs-release-precise.deb
sudo apt-get -y update
sudo apt-get -y install puppet vim git
