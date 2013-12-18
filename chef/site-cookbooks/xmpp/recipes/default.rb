#
# Cookbook Name:: xmpp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "logrotate"
tigase_version = "tigase-server-5.1.5-b3164"
tigase_bin_file = "#{tigase_version}.tar.gz"
tigase_bin_path = "#{Chef::Config['file_cache_path']}/#{tigase_bin_file}"
extract_to = "~/tigase"

# TODO - create a tigase user and run the server with that user
# user "tigase" do
# end

remote_file tigase_bin_path do
  action :create_if_missing
  source node[:xmpp][:tigase_server_bin_url]
  owner 'ubuntu'
  group 'ubuntu'
  mode 0644
end

bash 'extract_tigase' do
  code <<-EOH
    mkdir #{extract_to}_tmp
    tar xzf #{tigase_bin_path} -C #{extract_to}_tmp
    mv #{extract_to}_tmp/#{tigase_version} #{extract_to}
    chown -R ubuntu #{extract_to}
    chgrp -R ubuntu #{extract_to}
    chmod u+x #{extract_to}/scripts/tigase.sh
    rm -r #{extract_to}_tmp
    EOH
  not_if { ::File.exists?(extract_to) }
end

derby_bin_file = 'derby_bin.tar.gz'
derby_bin_path = "#{Chef::Config['file_cache_path']}/#{derby_bin_file}"
remote_file derby_bin_path do
  action :create_if_missing
  source node[:xmpp][:derby_bin_url]
  owner 'ubuntu'
  group 'ubuntu'
  mode 0644
end
bash 'extract_derby' do
  code <<-EOH
    mkdir /opt/Apache
    cp #{derby_bin_path} /opt/Apache
    cd /opt/Apache
    tar xzvf /opt/Apache/#{derby_bin_file}
    chown -R ubuntu /opt/Apache
    chgrp -R ubuntu /opt/Apache
    rm /opt/Apache/#{derby_bin_file}
    EOH
  not_if { ::File.exists?(extract_to) }
end


template "#{ENV['HOME']}/tigase/etc/init.properties" do 
  source "init.properties"
  owner 'ubuntu'
  group 'ubuntu'
  mode 0644
end

template "#{ENV['HOME']}/tigase/etc/tigase.conf" do 
  source "tigase.conf"
  owner 'ubuntu'
  group 'ubuntu'
  mode 0644
end