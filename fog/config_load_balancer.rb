load File.expand_path "requires.rb", File.dirname(__FILE__)

elb = Util.get_elb

lb = elb.load_balancers.find { |balancer| balancer.id == LOAD_BALANCER_ID }
lb ||= elb.load_balancers.create id: LOAD_BALANCER_ID
p "Connected to load balancer"

# TODO - hit a status page instead of checking for 'running'
good_server_ids = []
Util.get_connection.servers.each { |s| good_server_ids << s.id if s.state == "running" }

bad_server_ids = lb.instances - good_server_ids
lb.deregister_instances bad_server_ids unless bad_server_ids.empty?
p "Removed bad servers: #{bad_server_ids}"

new_server_ids = good_server_ids - lb.instances
lb.register_instances new_server_ids unless new_server_ids.empty?
p "Added new servers: #{new_server_ids}"

p "Live web servers: #{lb.instances}"





