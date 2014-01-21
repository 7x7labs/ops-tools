require_relative 'fog_demo.rb'

class Compute
  include FogDemo

  attr_accessor :compute

  def initialize 
    self.compute = Fog::Compute.new Fog.credentials
  end

  def debug 
    debugger
    p 1
  end

  def create_xmppserver
    p "Starting at #{Time.new}"
    
    # sg = compute.security_groups.find {|sg| sg.name == 'default' }
    # sg.authorize_port_range(5222..5223)
    # sg.authorize_port_range(5269..5229)
    # sg.authorize_port_range(5280..5280)

    server = create_server 'xmppserver', { image_id:           XMPP_SERVER_AMI,
                                    private_key_path:   PRIVATE_KEY_PATH,
                                    public_key_path:    PUBLIC_KEY_PATH,
                                    flavor_id:          'c1.medium',
                                    username:           'ubuntu'
                                  }
    p "Finished at #{Time.new}, public ip:"
    p server.public_ip_address
  end

  def update_xmppserver
    compute.servers.each { |server|
      next unless server.tags['Name'] == 'xmppserver'
      next if server.state == 'terminated'
      #server.username = 'deploy'
      server.private_key_path = PRIVATE_KEY_PATH

      cmds = ["sudo chef-client -o 'role[xmppserver]'",
              "echo 'done'"]

      p "Updating xmppserver: #{server.id}"
      run_ssh server, cmds
    }
  end

  def create_webserver
    server = create_server 'webserver', { image_id:           WEB_SERVER_AMI,
                                          private_key_path:   PRIVATE_KEY_PATH,
                                          public_key_path:    PUBLIC_KEY_PATH,
                                          instance_type:      't1.tiny',
                                          username:           'ubuntu'
                                        }
    p "created server"
    
    update_webserver server
    p "Installed gems, Updated sinatra app, and started up puma."  
  end

  def update_webservers
    compute.servers.each { |server|
      next unless server.state == 'running'
      update_webserver server
    }
  end

  def update_webserver server
    # server.username = 'ubuntu'
    server.private_key_path = PRIVATE_KEY_PATH

    commands = [  
                "sudo chef-client -o 'role[webserver]'",
                'sudo rm -rf /var/www/fogdemo/*',
                'sudo rm -rf /var/www/fogdemo/\.*',
                "echo 'cloning repo'",
                'cd /var/www/fogdemo; pwd; git clone https://github.com/splap/seven-web.git .; mkdir -p tmp/puma;',
                "export PATH=/opt/rbenv/shims:/opt/rbenv/bin:$PATH; cd /var/www/fogdemo; echo 'Installing Bundler as '; echo $PATH; bundle install;",
                'sudo start puma-manager',
                "echo 'started puma-manager'"]
                
    
    p "Updating webserver: #{server.id}"
    run_ssh server, commands
  end

  def destroy_servers 
    compute.servers.each { |server|
      destroy_server server.id unless server.state == 'terminated'
    }
  end

  def destroy_server server_id
    compute.servers.each { |server|
      next unless server_id == server.id
      server.destroy 
      p "Destroyed server #{server.id}"
    }
  end

  private

  def run_ssh server, commands
    stdout_helper = Proc.new { |stdout| STDOUT.write stdout[0] }
    server.ssh commands, &stdout_helper 
  end

  def create_server role, attrs={}
    Fog.credential = :aws_fog_id_rsa

    server = compute.servers.bootstrap( { name: role, tags: { "Name" => role } }.merge(attrs) )
    
    system  "cd chef; knife bootstrap #{server.public_ip_address} -x ubuntu " + 
            "-i #{PRIVATE_KEY_PATH} --sudo -V --run-list 'role[#{role}]'"
    p "Bootstrapped chef client and assigned the role: #{role}"

    server 
  end

end