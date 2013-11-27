load File.expand_path "requires.rb", File.dirname(__FILE__)

connection = Util.get_connection
p "Connected to fog compute."

server = connection.servers.bootstrap private_key_path: PRIVATE_KEY_PATH,
                                      public_key_path:  PUBLIC_KEY_PATH,
                                      username:         'ubuntu',
                                      flavor_id:        'm1.small'
p "Created server: #{server.public_ip_address}, SSH keys are in #{SSH_DIR}"

system  "cd chef; knife bootstrap #{server.public_ip_address} -x ubuntu " + 
        "-i #{PRIVATE_KEY_PATH} --sudo -V --run-list 'role[webserver]'"
p "Bootstrapped chef client and installing web server prereqs"


# TODO call update webservers
