require_relative 'fog_demo.rb'

class Chef
  include FogDemo

  def self.push_cookbook
    system "cd chef; knife role from file roles/webserver.rb"
    system "cd chef; knife cookbook upload 'fogdemo'"
  end

end