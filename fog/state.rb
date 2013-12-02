require_relative 'fog_demo.rb'

class State
  include FogDemo

  attr_accessor :dns, :lb, :compute

  def initialize 
    self.dns = DNS.new().dns
    self.lb = LoadBalancer.new().lb
    self.compute = Compute.new()
  end

  def show_state
    p "DNS ZONE CONFIG"
    zone = dns.zones.first.reload
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
    ap lb.attributes.select { |k,v| 
      [:id, :domain, :created_at, :instances].include?(k)
    }

    p "WEB SERVERS CONFIG"
      compute.connection.servers.each { |server| 
        next unless server.state == "running"
        ap server.attributes.select { |k,v|
          [:id, :state, :public_ip_address, :private_ip_address, :created_at, :flavor_id].include?(k)
        }
    }
  end
end
