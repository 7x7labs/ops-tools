require_relative 'fog_demo.rb'

class Compute
  include FogDemo

  attr_accessor :connection

  def initialize
    self.connection = Fog::Compute.new( AWS_CREDENTIALS.merge provider: 'AWS' )
  end

  def create_webserver
    server = connection.servers.bootstrap  private_key_path:  PRIVATE_KEY_PATH,
                                            public_key_path:  PUBLIC_KEY_PATH,
                                            username:         'ubuntu',
                                            flavor_id:        'm1.small',
                                            image_id:         SERVER_IMAGE_ID
    p "Created server: #{server.public_ip_address}, SSH keys are in #{SSH_DIR}"

    system  "cd chef; knife bootstrap #{server.public_ip_address} -x ubuntu " + 
            "-i #{PRIVATE_KEY_PATH} --sudo -V --run-list 'role[webserver]'"
    p "Bootstrapped chef client and installed web server prereq's"

    update_webserver server
    p "Installed gems, Updated sinatra app, and started up puma."

  end

  def update_webservers
    connection.servers.each { |server|
      next unless server.state == 'running'
      update_webserver server
    }
  end

  def update_webserver server
    server.username = 'ubuntu'
    server.private_key_path = PRIVATE_KEY_PATH

    commands = [  "sudo chef-client -o 'role[webserver]'",
                  'sudo rm -rf /var/www/fogdemo/*',
                  'sudo rm -rf /var/www/fogdemo/\.*',
                  "echo 'cloning repo'",
                  'cd /var/www/fogdemo; pwd; git clone https://github.com/splap/seven-web.git .; mkdir -p tmp/puma;',
                  "export PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH; cd /var/www/fogdemo; echo 'Installing Bundler as '; echo $PATH; bundle install;",
                  'sudo start puma-manager',
                  "echo 'started puma-manager'"]
    
    p "Updating webserver: #{server.id}"
    stdout_helper = Proc.new { |stdout| STDOUT.write stdout[0] }
    server.ssh commands, &stdout_helper 
  end

  def destroy_servers 
    connection.servers.each { |server|
      destroy_server server.id
    }
  end

  def destroy_server server_id
    connection.servers.each { |server|
      next unless server_id == server.id
      
      if server.state == 'running'
        server.destroy 
        p "Destroyed server #{server.id}"
      end
    }
  end

end