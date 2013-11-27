load File.expand_path "requires.rb", File.dirname(__FILE__)

conn = Util.get_connection

conn.servers.each { |server|

  next unless server.state == 'running'
  
  server.username = 'ubuntu'
  server.private_key_path = PRIVATE_KEY_PATH

  

  commands = [  "sudo chef-client -o 'role[webserver]'",
                'sudo rm -rf /var/www/fogdemo/*',
                'sudo rm -rf /var/www/fogdemo/\.*',
                'cd /var/www/fogdemo; pwd; git clone https://github.com/splap/seven-web.git .; mkdir -p tmp/puma',
                'sudo start puma-manager',
                "echo 'started puma-manager'"]
  
  p "Updating webserver: #{server.id}"
  stdout_helper = Proc.new { |stdout| STDOUT.write stdout[ 0] }
  server.ssh commands, &stdout_helper 

}

