module FogDemo
  require 'rubygems'
  require 'fog'
  require 'awesome_print'
  require 'debugger'
  require 'rake'

  DOMAIN_NAME       = 'splap.net'
  DOMAIN_NAME_DOT   = 'splap.net.'
  LOAD_BALANCER_ID  = 'fogdemo'
  WEB_SERVER_AMI    = 'ami-c5a98cac'
  XMPP_SERVER_AMI   = 'ami-2f774746'
  XMPP_VERSION      = '5.1.5-b3164'
  PROVIDER          = ENV['FOG_CREDENTIAL']
  SSH_DIR           = '~/.ssh/fogdemo'
  PUBLIC_KEY_PATH   = '~/.ssh/fogdemo/aws_fog_id_rsa.pub'
  PRIVATE_KEY_PATH  = '~/.ssh/fogdemo/aws_fog_id_rsa'
end
