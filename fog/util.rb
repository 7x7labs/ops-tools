module Util
  
  def self.get_dns 
    Fog::DNS.new  provider:               'AWS',
                  aws_access_key_id:      ENV['AWS_ID'],
                  aws_secret_access_key:  ENV['AWS_SECRET']
  end

  def self.get_elb
    Fog::AWS::ELB.new aws_access_key_id:      ENV['AWS_ID'],
                      aws_secret_access_key:  ENV['AWS_SECRET']
  end

  def self.get_connection
    Fog::Compute.new  provider:               'AWS',
                      aws_access_key_id:      ENV['AWS_ID'],
                      aws_secret_access_key:  ENV['AWS_SECRET']
  end

end