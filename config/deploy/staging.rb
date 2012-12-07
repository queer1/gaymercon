role :web, "staging.gaymercon.org"                          # Your HTTP server, Apache/etc
role :app, "staging.gaymercon.org"                          # This may be the same as your `Web` server
role :db,  "staging.gaymercon.org", :primary => true # This is where Rails migrations will run