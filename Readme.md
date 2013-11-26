FogDemo  
=========

This is a devops demo using [Fog] [fog github] and [Chef] [chef]. It does a few things:

  - spins up ec2 web servers
  - installs chef clients on the web servers
  - installs and configures rbenv, nginx, git, etc
  - delpoys a sinatra web app
  - launches and configures load balancer
  - configures dns for the app

This has only been tested on OS X with rbenv / 1.9.3-p429 available, and bundler installed

Clone the repo and install gems
--
```sh
cd ~ 
git clone git@github.com:splap/fogdemo.git
cd fogdemo 
bundle install
```
Set up Chef
--
Create a free hosted chef account at [OpsCode] [chef signup]
and save your private key as fogdemo.pem and set permissions
```sh
chmod og-r ~/.ssh/fogdemo/fogdemo.pem
```
Install knife and create a Chef Client for our new hosted chef account.
```sh
cd ~/fogdemo/chef
sudo gem install chef --no-ri --no-rdoc

knife client create fogclient -a -f "~/ssh/fogdemo/validator.pem"

# see the new client
knife client list
```
Fetch cookbook declarations from OpsCode and upload them your hosted chef account
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
Configure DNS and load balancing
--
Connect to or create a load balancer and tell it which web instance to use
```
rake lb
```
Configure DNS. Points an alias A record at the load balancer
```
rake dns
```
Care and feeding
--
Get an overview of the app's cloud deployment
```
rake get_info
```
Update all webservers. This will apply chef configuration changes and update the sinatra app.
This would not work in a zero downtime deploy strategy without more effort.
```
rake update_web
```
Testing helpers
--
Stop and abandon all existing servers
```
rake kill_all
```
Stops you in a RELP with required code loaded, and some handy fog classes instantiated
```
rake debug
````

[fog github]: https://github.com/fog/fog
[chef]: http://www.opscode.com/chef/
[chef signup]: https://getchef.opscode.com/signup
