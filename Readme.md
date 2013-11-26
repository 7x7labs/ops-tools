FogDemo  
=========

This is a little devops demo using [Fog] [fog github] and [Chef] [chef]. It does a few things:

  - spins up ec2 web servers
  - installs chef clients on the web servers
  - installs and configures rbenv, nginx, git, etc
  - delpoys a sinatra web app
  - launches and configures load balancer
  - configures dns for the app

It assumes you're running OS X, rbenv with ruby 1.9.3-p429 available, with bundler installed

Clone the repo and install gems
--
```sh
cd ~ 
git clone git@github.com:splap/fogdemo.git
bundle install
```
Set up Chef
--

Create a free hosted chef account at [OpsCode] [chef signup]
and save your private key as fogdemo.pem and set permissions
```sh
chmod og-r ~/fogdemo/chef/.chef/fogdemo.pem
```

Install knife and create a Chef Client for our new hosted chef account.
```sh
cd ~/fogdemo/chef
sudo gem install chef --no-ri --no-rdoc

knife client create fogclient -a -f "~/ssh/fogdemo/validator.pem"

# see the new client
knife client list
```
Fetch cookbook declarations and upload them to chef server
```sh
cd ~/fogdemo/chef
librarian-chef install --clean --verbose
knife cookbook upload --all
```
Upload webserver role on the hosted chef server
```sh
knife role from file roles/webserver.rb
```
Spin up a webserver
--
Fog creates a server, and bootstraps chef. chef installs rbenv, git, nginx, logrotate, etc. Also deploys a sinatra app
```sh
rake create_webserver
```
Launch and configure load balancer
--
Creates and configures dns for the app

http://dillinger.io/

[fog github]: https://github.com/fog/fog
[chef]: http://www.opscode.com/chef/
[chef signup]: https://getchef.opscode.com/signup
