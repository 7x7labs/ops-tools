
knife client create fogclient -a -f ".chef/49-validator.pem"

knife client list

knife cookbook create xmpp

# looks at each cookbook declaration and fetches the cookbook from the source specified, 
# or from the default source if none is provided.
librarian-chef install --clean --verbose

# upload all the cookbooks to hosted chef server
knife cookbook upload --all

# updaload a cookbook
knife cookbook upload "fogdemo"

# delete all cookbooks from hosted server
knife cookbook bulk delete ".*"

# update a role on the chef server
knife role from file roles/webserver.rb

# in a node ssh session, use chef-client to update box. specify role if you want
sudo chef-client
sudo chef-client -o role[webserver]

# add a role to a server
knife exec -E 'nodes.transform("name:ec2-107-22-13-171.compute-1.amazonaws.com") {|n| n.run_list(["role[webserver]"])}'

# list ec2 nodes
knife ec2 server list --region 'us-west-1'

# create a ec2 node in us west 1
knife ec2 server create -I ami-26745463 -x ubuntu --region 'us-west-1' -f 't1.micro' -r 'role[webserver]'

# delete a node in hosted chef and ec2
knife ec2 server delete i-be565ae7 -P -V --region 'us-west-1'