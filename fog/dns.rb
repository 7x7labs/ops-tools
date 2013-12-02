require_relative 'fog_demo.rb'

class DNS
  include FogDemo

  attr_accessor :dns, :lb

  def initialize
    elb = Fog::AWS::ELB.new aws_access_key_id:      ENV['AWS_ID'],
                            aws_secret_access_key:  ENV['AWS_SECRET']
    
    self.lb = elb.load_balancers.find { |balancer| balancer.id == LOAD_BALANCER_ID }

    self.dns = Fog::DNS.new provider:               'AWS',
                        aws_access_key_id:      ENV['AWS_ID'],
                        aws_secret_access_key:  ENV['AWS_SECRET']
    self
  end

  def configure_dns
    dns_records = [ 
      { type: 'A', name: 'splap.net.', alias_target: {  hosted_zone_id: self.lb.hosted_zone_name_id, 
                                                        dns_name:       self.lb.dns_name }},
      { type: 'CNAME', name: 'www.splap.net.', value: self.lb.dns_name },
      { type: 'MX', name: 'splap.net', value: [ '20 alt1.aspmx.l.google.com',
                                                '30 alt2.aspmx.l.google.com',
                                                '10 aspmx.l.google.com',
                                                '40 aspmx2.googlemail.com',
                                                '50 aspmx3.googlemail.com' ] }
    ]

    splap_zone = self.dns.zones.find{ |zone| zone.domain == DOMAIN_NAME_DOT } if self.dns.zones
    splap_zone ||= self.dns.zones.create domain: DOMAIN_NAME, email: 'admin@splap.net'
    p "Connected to dns zone for #{DOMAIN_NAME}"

    p "You must set these nameservers on the domain host to go live."
    splap_zone.reload.nameservers.each { |ns| p "    #{ns}" }

    # destroy each of the old dns records
    splap_zone.records.each { |record| record.ttl ||= 1000; record.destroy }

    dns_records.each do |record_attrs|
      record = splap_zone.records.create record_attrs
      p "Created '#{record.type}' record."
    end  
  end
  
end
