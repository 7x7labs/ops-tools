load File.expand_path("requires.rb", File.dirname(__FILE__))

p "DNS ZONE CONFIG"
zone = Util.get_dns.zones.first.reload
ap zone.attributes.select { |k,v| 
  [:id, :domain, :created_at, :nameservers].include?(k)
}

p "DNS RECORD CONFIG"
zone.records.each { |record|
  ap record.attributes.select { |k,v| 
    [:value, :name, :type].include?(k) 
  }
}

p "LOAD BALANCER CONFIG"
ap Util.get_elb.load_balancers.first.attributes.select { |k,v| 
  [:id, :domain, :created_at, :instances].include?(k)
}

p "WEB SERVERS CONFIG"
Util.get_connection.servers.each { |server| 
  next unless server.state == "running"
  ap server.attributes.select { |k,v|
    [:id, :state, :public_ip_address, :private_ip_address, :created_at, :flavor_id].include?(k)
  }
}

