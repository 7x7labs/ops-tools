default[:unicorn][:port]                = 3333
default[:nginx][:default_site_enabled]  = false
default[:rbenv][:group_users]           = ["ubuntu","www-data"]

default[:fogdemo][:environment]     = 'production' 
default[:fogdemo][:site_root]       = '/var/www/fogdemo'
default[:fogdemo][:ruby_version]    = '1.9.3-p429'