require 'librarian/chef/integration/knife'

current_dir = File.dirname(__FILE__)
log_level                :debug
log_location             STDOUT
node_name                "fogdemo"

#hosted chef settings 
validation_client_name   "49-validator"
client_key               "#{ENV['HOME']}/.ssh/fogdemo/fogdemo.pem"
validation_key           "#{ENV['HOME']}/.ssh/fogdemo/49-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/49"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

cookbook_path            Librarian::Chef.install_path, File.expand_path('../../site-cookbooks', __FILE__)

knife[:aws_ssh_key_id]        = "7x7_aws_west_1"
knife[:aws_access_key_id]     = ENV['AWS_ID']
knife[:aws_secret_access_key] = ENV['AWS_SECRET']


# See http://docs.opscode.com/config_rb_knife.html for moconfiguration options

