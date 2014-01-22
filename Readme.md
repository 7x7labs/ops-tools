Ops Tools 
=========

This repo contains rake tasks to automate some of our DevOps needs. It makes use of [Fog] [fog github] and [Chef] [chef] to create and configureservers in the cloud.

Openstack compatability is broken at this time. 

create up ec2 web servers
--
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
Fetch cookbook declarations from OpsCode
```sh
cd ~/fogdemo/chef
librarian-chef install --clean --verbose
```
Upload roles and cookbooks to hosted chef server
```sh
rake push_chef_updates
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
Update all webservers. This will apply chef configuration changes and update the sinatra app.
This would not work in a zero downtime deploy strategy without more effort.
```sh
rake update_web
```
Care and feeding
--
Get an overview of the app's cloud deployment (default rake task)
```sh
rake
```
Stop and destroy a web server
```sh
rake destroy_server['server_id']
```
Stop and abandon all existing servers
```sh
rake destroy_all
```
XMPP
--
Upload xmpp role on the hosted chef server
```sh
knife role from file roles/xmppserver.rb
```
Create a new xmpp server - installs chef client and runs xmpp role, installing java, tigase, derby db, etc.
```sh
rake create_xmpp
```
Update all xmpp servers
```sh
rake update_xmpp
```

[fog github]: https://github.com/fog/fog
[chef]: http://www.opscode.com/chef/
[chef signup]: https://getchef.opscode.com/signup
