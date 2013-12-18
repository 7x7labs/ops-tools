Dir[File.dirname(__FILE__) + "/fog/*.rb"].each { |f| require f }

task :default => [:info]

desc "Prints state information about load balancer, dns, and webservers"
task :info do
  State.new().show_state
end

desc "Spins up a web server and installs app and its prerequisites"
task :create_web do
  Compute.new().create_webserver
end

desc "Create an AWS Load Balancer and configure."
task :create_lb do
  lb = LoadBalancer.new
  lb.new
  lb.configure
end

desc "Destroy an AWS Load Balancer."
task :destroy_lb do
  lb = LoadBalancer.new
  lb.destroy
end

desc "Create DNS zone if necessary and configure"
task :dns do
  DNS.new().configure_dns
end

desc "Update cookbook and role"
task :push_cookbook do
  Chef.push_cookbook
end

desc "Update webservers with latest chef config and app code"
task :update_web => :push_cookbook do
  Compute.new().update_webservers
end

desc "Update xmpp seervers with latest chef and tigase config"
task :update_xmpp => :push_cookbook do
  Compute.new().update_xmppserver
end

desc "Destroy any active compute instances."
task :destroy_all do
  Compute.new().destroy_servers
end

desc "Destroy a single web server."
task :destroy_server, :server_id do |t, args|
  Compute.new().destroy_server args['server_id']
end

desc "Spins up an xmpp server"
task :create_xmpp do
  Compute.new().create_xmppserver
end
