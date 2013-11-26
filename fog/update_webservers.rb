load File.expand_path("requires.rb", File.dirname(__FILE__))

conn = Util.get_connection

conn.servers.each { |server|

  next unless server.state == 'running'
  
  server.username = 'ubuntu'
  server.private_key_path = PRIVATE_KEY_PATH

  

  commands = [  "sudo chef-client -o 'role[webserver]'",
                'cd /var/www/fogdemo; if [ -f .git/config ]; then git pull; else git clone https://github.com/splap/seven-web.git .; fi' ]
  
  p "Updating webserver: #{server.id}"
  stdout_helper = Proc.new { |stdout| STDOUT.write stdout[ 0] }
  server.ssh commands, &stdout_helper 

#               # 'rackup config.ru -p 3000 -D']


}

