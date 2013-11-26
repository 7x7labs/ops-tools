load File.expand_path("requires.rb", File.dirname(__FILE__))

Util.get_connection.servers.each { |server|
  if server.state == 'running'
    server.destroy 
    p "Destroyed server #{server.id}"
  end
}
