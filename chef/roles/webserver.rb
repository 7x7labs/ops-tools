name "webserver"
description "A sinatra web server"

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list  [ "recipe[git]",
            "recipe[apt]",
            "recipe[ntp]",
            "recipe[nginx]",
            "recipe[fogdemo]",
            "recipe[fogdemo::nginx]"
          ]

# Attributes applied if the node doesn't have it set already.
#default_attributes()

# Attributes applied no matter what the node has set already.
#override_attributes()