GaymerCon -- Everyone Games
===========================
This is the official, open-source repo for the web end of [GaymerCon](http://www.gaymercon.org). We want to let everyone participate in creating the ultimate social space for Gaymers, and now you can! Just fork the repo, make your changes, and issue a pull request! Our admins will take a look at it, do a code review, apply your changes and deploy. It's that easy!

We will be setting up tasks anyone can take on via [Github Issues](https://github.com/agius/gaymercon/issues), so if you feel the need, grab a ticket and go! We are also coordinating and brainstorming on [our Facebook group](https://www.facebook.com/groups/gaymerconnect/), and I'm very open to suggestions on [my Twitter](http://twitter.com/agius) or via email at <admin@gaymercon.org>.

Setup
-----
Gaymercon is a [Ruby on Rails](http://guides.rubyonrails.org/) application that uses [MySQL](http://dev.mysql.com/doc/refman/5.1/en/index.html) and [MongoDB](http://www.mongodb.org/display/DOCS/Home;jsessionid=859A75B226E69E7A4D2829753253B330). It takes a bit of setup to get it running.

Mac OS X
--------
1. Make sure you're running at least ruby 1.9.2. We recommend using [rbenv](https://github.com/sstephenson/rbenv), and [ruby-build](https://github.com/sstephenson/ruby-build). These can both be installed super fast with [Homebrew](http://mxcl.github.com/homebrew/), which is a great package manager for Mac OS X.
2. Install [bundler](http://gembundler.com/)
3. Clone the repo: `git clone git@github.com:agius/gaymercon.git`
4. Install gems: `cd gaymercon && bundle install`
5. Make sure you have MySQL, MongoDB installed. These can both be installed via Homebrew.
6. Make sure you have Redis installed in the default configuration. This can also be installed via Homebrew.
7. Go into the /config directory and copy each of the .yml.dist files to a regular .yml file. Make sure database.yml points to your MySQL installation, and that mongoid.yml points to your MongoDB installation.
8. (optional) If you want to enable Facebook authentication, geolocation via Yahoo! geocoding APIs, you will need to create your own apps for those. The URLs to do so are in the config files.
9. Run `rake db:create` to create your MySQL database.
10. Run `rake db:schema:load` to bootstrap your MySQL database.
11. Run `rake db:mongoid:create_indexes` to create the necessary mongo collections & indexes.
12. Run `bundle exec rake sunspot:solr:start` to start up the Solr server.
13. Run `rails s` to start up a rails server. If it starts up correctly, go to it in your favorite web browser. If it works, you're set!

Testing
-------
Rspec is used for unit testing and cucumber is used for feature/acceptance testing (no Test::Unit)

1. Run `rake db:test:prepare` to create the test database and load the fixtures.
2. If you would like to use guard with growl (as it's set up), purchase [Growl](http://growl.info/) or install the [Growl Fork](http://www.macupdate.com/app/mac/41038/growl-fork) (make sure to install growlnotify from the fork as well)
3. Run `bundle exec guard` to start up your guard server, which will watch for changes and re-run your tests accordingly.

That should be it. If you have any issues, feel free to ping me on [our facebook group](https://www.facebook.com/groups/gaymerconnect/) or on [my Twitter](http://twitter.com/agius), or email me at <admin@gaymercon.org>.

![GaymerCon](http://gaymercon.org/img/gaymercon-feature-bg.png)