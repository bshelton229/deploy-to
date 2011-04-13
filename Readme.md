# DeployTo

A rubygem application that lets you deploy via rsync using --excludes and host information defined in a config file within your project.

## Getting Started

To install, open up your terminal and type `sudo gem install deploy-to`. 

Once you've installed the gem, you'll need to put the a file named deploy-to.yml on the root of your site (see example below). When you're ready to push your changes live, open a terminal and change the directory to be at your project root: `cd ~/Sites/myproject`. Then type `d2 -n production` to preview the files which will be changed, or `d2 production` to update, post, or delete all files automatically to sync your local version with your remote version (sans the files you are ignoring in the deploy-to.yml document). 

It is helpful to use an SSH key on your server if you don't want to enter your password every time you do this.

You can name the remotes whatever make sense for you. For instance, instead of _production_ and _dev_, you might have _live_, _dev_, and _newhost_. Please note, the indents on this file are important. If you change the tabs, this will error out.

`--d2 help` will list the available options. 

## Example of deploy-to.yml
    
    # Ignore files, relative from base (currently base is the root of the project only)
    ignore: [
      .htaccess,
      .DS_Store,
      '!/test/.htaccess'
    ]
    
    # OPTIONAL: Re-define the base relative to the project root.
    # If this is not set, the base will be the project root.
    # base: lib

    # deploy-to sites definition
    remotes:
      # Production server
      production:
        host: example.com
        user: bshelton
        path: ~/example.com/
        post_commands: ['~/bin/cleanup.sh', 'rake db:migrate']
      
      # Dev Server
      dev:
        host: dev.example.com
        user: bshelton
        path: ~/dev.example.com
        identity_file: ~/.ssh/this_server.pub
        port: 111
