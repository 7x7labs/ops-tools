Ops Tools 
=========

This is a devops demo using [Fog] [fog github] and [Chef] [chef]. It does a few things:

create up ec2 web servers

  - installs chef clients on the web servers
  - installs and configures rbenv, nginx, git, etc
  - delpoys a sinatra web app
  - launches and configures load balancer
  - configures dns for the app

creates ec2 xmpp servers

  - installs chef clients on the xmpp servers
  - installs and configures git, java, tigase

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
Fog creates a server, and bootstraps chef. chef installs rbenv, git, nginx, logrotate, etc. It then pulls a sinatra app, installs required gems, and starts up puma.
```sh
rake create_web
```
Configure DNS and load balancing
--
Connect to or create a load balancer and tell it which web instance to use
```sh
rake lb
```
Configure DNS. Points an alias A record at the load balancer
```sh
rake dns
```
Care and feeding
--
Get an overview of the app's cloud deployment (default rake task)
```sh
rake
```
Update all webservers. This will apply chef configuration changes and update the sinatra app.
This would not work in a zero downtime deploy strategy without more effort.
```sh
rake update_web
```
Stop and abandon a web server
```sh
rake destroy_server['server_id']
```
Stop and abandon all existing servers
```sh
rake destroy_all
```


[fog github]: https://github.com/fog/fog
[chef]: http://www.opscode.com/chef/
[chef signup]: https://getchef.opscode.com/signup
