task :default => [:info]

desc "Prints useful state info about load balancer, dns, and webservers"
task :info do
  ruby "fog/get_info.rb"
end

desc "Spin up a web server with app and prerequisites"
task :create_web do
  ruby "fog/create_webserver.rb"
end

desc "Create Load Balancer if necessary and configure."
task :lb do
  ruby "fog/config_load_balancer.rb"
end

desc "Create DNS zone if necessary and configure"
task :dns do
  ruby "fog/config_dns.rb"
end

desc "Update cookbook and role"
task :push_cookbook do
  system "cd chef; knife role from file roles/webserver.rb"
  system "cd chef; knife cookbook upload 'fogdemo'"
end

desc "Update webservers with latest chef config and app code"
task :update_web => :push_cookbook do
  ruby "fog/update_webservers.rb"
end

desc "Destroy any active server instances."
task :kill_all do
  ruby "fog/destroy_servers.rb"
end

desc "Convenience task for debugging: creates Fog objects and pauses"
task :debug do
  ruby "fog/debug_helper.rb"
end


