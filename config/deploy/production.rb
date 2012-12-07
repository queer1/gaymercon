role :web, "gibson.gaymercon.org"                          # Your HTTP server, Apache/etc
role :app, "gibson.gaymercon.org"                          # This may be the same as your `Web` server
role :db,  "gibson.gaymercon.org", :primary => true # This is where Rails migrations will run
