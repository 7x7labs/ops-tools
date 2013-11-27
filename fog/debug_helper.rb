load File.expand_path "requires.rb", File.dirname(__FILE__)

dns = Util.get_dns
elb = Util.get_elb
conn = Util.get_connection


debugger
p 1