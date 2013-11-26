require 'rubygems'
require 'fog'
require 'awesome_print'
require 'debugger'
require 'rake'
require File.expand_path("util.rb", File.dirname(__FILE__))

DOMAIN_NAME       = "splap.net"
DOMAIN_NAME_DOT   = "splap.net."
LOAD_BALANCER_ID  = "fogdemo"
SSH_DIR           = "~/.ssh/fogdemo"
PRIVATE_KEY_PATH  = "~/.ssh/fogdemo/aws_fog_id_rsa"
PUBLIC_KEY_PATH   = "~/.ssh/fogdemo/aws_fog_id_rsa.pub"