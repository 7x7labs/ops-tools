require_relative 'fog_demo.rb'

class State
  include FogDemo

  attr_accessor :dns, :lb, :compute

  def initialize
    self.compute = Fog::Compute.new provider: 'aws'
    p "compute #{self.compute}"
  end

  def show_state
    p "DNS ZONE CONFIG"
    zone = dns.zones.first.reload unless dns.nil?
    ap zone.attributes.select { |k,v| 
      [:id, :domain, :created_at, :nameservers].include?(k)
    } unless zone.nil?

    p "DNS RECORD CONFIG"
    zone.records.each { |record|
      ap record.attributes.select { |k,v| 
        [:value, :name, :type].include?(k) 
      }
    } unless zone.nil?

    p "LOAD BALANCER CONFIG"
    ap lb.attributes.select { |k,v| 
      [:id, :domain, :created_at, :instances].include?(k)
    } unless lb.nil?

    p "WEB SERVERS CONFIG"
    compute.servers.each { |server| 
      ap server.attributes.select { |k,v|
        [:id, :name, :state, :public_ip_address, :private_ip_address, :created_at, :flavor_id].include?(k)
      }
    } unless compute.nil?
  end
end
