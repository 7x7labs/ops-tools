#
# Cookbook Name:: fogdemo
# Recipe:: default
#
# Copyright 2013, 7x7 Labls
#
# No rights reserved
#
package "logrotate"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby node['fogdemo']['ruby_version']

rbenv_gem "bundler" do 
  ruby_version node['fogdemo']['ruby_version']
end

directory "#{node['fogdemo']['site_root']}" do
  action :create
  owner "ubuntu"
  group 'rbenv'
  mode 0755
  recursive true
end

directory "/var/log/fogdemo" do
  action :create
  owner "ubuntu"
  group 'root'
  mode 0755
  recursive true
end

template "/etc/init/puma-manager.conf" do 
  source "init.puma-manager.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
end

template "/etc/init/puma.conf" do 
  source "init.puma.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
end

template "/etc/puma.conf" do
  source "puma.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
end
