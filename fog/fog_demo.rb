module FogDemo
  require 'rubygems'
  require 'fog'
  require 'awesome_print'
  require 'debugger'
  require 'rake'

  DOMAIN_NAME       = 'splap.net'
  DOMAIN_NAME_DOT   = 'splap.net.'
  LOAD_BALANCER_ID  = 'fogdemo'
  SERVER_IMAGE_ID   = 'ami-95ac89fc'
  SSH_DIR           = '~/.ssh/fogdemo'
  PRIVATE_KEY_PATH  = '~/.ssh/fogdemo/aws_fog_id_rsa'
  PUBLIC_KEY_PATH   = '~/.ssh/fogdemo/aws_fog_id_rsa.pub'
  AWS_CREDENTIALS   = { aws_access_key_id: ENV['AWS_ID'],
                        aws_secret_access_key:  ENV['AWS_SECRET'] }
end
