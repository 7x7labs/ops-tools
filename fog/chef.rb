require_relative 'fog_demo.rb'

class Chef
  include FogDemo

  def self.push_updates
    system "cd chef; knife role from file roles/webserver.rb"
    system "cd chef; knife role from file roles/xmppserver.rb"
    system "cd chef; knife cookbook upload -a -o ./site-cookbooks"
  end

end