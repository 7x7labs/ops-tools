template "/etc/init/fogdemo.conf" do 
  source "upstart/fogdemo.conf.erb" 
  owner 'root' 
  group 'root' 
  mode 0644
end

