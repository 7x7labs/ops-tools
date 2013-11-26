template "#{node['nginx']['dir']}/sites-available/fogdemo" do 
  source "nginx/fogdemo.conf.erb" 
  owner 'root' 
  group 'root' 
  mode 0644
end

nginx_site "fogdemo" do 
  action :enable
end

execute "restart nginx" do
  command "sudo service nginx restart"
end
