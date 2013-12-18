name "xmppserver"
description "Xmpp server running a tigase xmpp server"

# List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
run_list  [ "recipe[git]",
            "recipe[apt]",
            "recipe[ntp]",
            "recipe[java]",
            "recipe[xmpp]"
          ]