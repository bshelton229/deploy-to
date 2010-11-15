# DeployTo

A rubygem application that lets you deploy via rsync using --excludes and host information defined in a config file within your project.

## Example deploy-to.yml
    
    # Ignore files, relative from base (currently base is the root of the project only)
    ignore: [
      .htaccess,
      .DS_Store
    ]

    # deploy-to sites definition
    remotes:
      # Production server
      production:
        host: example.com
        user: bshelton
        path: ~/example.com/
      
      # Dev Server
      dev:
        host: dev.example.com
        user: bshelton
        path: ~/dev.example.com
