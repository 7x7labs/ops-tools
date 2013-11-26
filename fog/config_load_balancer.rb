load File.expand_path("requires.rb", File.dirname(__FILE__))

elb = Util.get_elb

lb = elb.load_balancers.find { |lb| lb.id == LOAD_BALANCER_ID }
lb ||= elb.load_balancers.create id: LOAD_BALANCER_ID
p "Connected to load balancer"


webservers = Util.get_connection.servers.each { |server| 
  if server.state == "running"  
    lb.register_instances [server.id] unless lb.instances.include? server.id
  else
    lb.deregister_instances [server.id] if lb.instances.include? server.id
  end
}
p "Registed web servers: #{lb.instances} with load balancer"





