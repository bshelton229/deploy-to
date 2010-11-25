require 'optparse'

module DeployTo
  class CLI
    
    attr_reader :config, :rsync

    def initialize
      #Parse the CLI options with optparse
      parse_options
      
      @config = DeployTo::Config.get_config
      @command = false
      @rsync = `which rsync`.chop

      # Configuration Base
      @real_base = File.expand_path('../',DeployTo::Config.config_file)
      
      # Find our base dir
      @base_dir = File.expand_path('../',DeployTo::Config.config_file)

      #Set what will not be @site_name after running optparse
      @remote_name = ARGV.shift
      
      # Parse the config file and the @site_name
      # to see if we should continue. This method will exit1
      # if there are any problems.
      parse_config
    
    end
    
    # Run the command
    def run
      build_command
      puts "Deploying to #{@remote_name}:\n"
      # Display a message if we're only doing a dry run
      if @dry_run
        puts "Dry run only -->\n"
      end
      run_command
    end
    
    private

    # Build the rsync command to run
    def build_command
      
      # Initialise the excludes array
      excludes = Array.new
      
      # Fill the excludes array from the excludes listed in the config file
      if(@config.has_key?('ignore'))
        if not @config['ignore'].empty?
          @config['ignore'].each do |ignore|
            # Ability here to check for ! to see if we should use --include
            if(ignore[0,1] == "!")
              ignore.slice!(0)
              excludes << " --include \'#{ignore}\'"
            else
              excludes << " --exclude \'#{ignore}\'"
            end
          end
        end
      end
      
      # Build the CLI excludes arguments for rsync
      exclude_cli = excludes.empty? ? '' : excludes.join
      
      # If we're in a dry run, set the rsync option
      dry_run = @dry_run ? ' --dry-run' : ''
      
      # Define the command
      @command = "#{@rsync} -aiz --no-t --no-p --checksum --delete#{dry_run} --exclude '.git' --exclude '.svn' --exclude '.gitignore' --exclude 'deploy-to.yml'#{exclude_cli} #{@base_dir}/ #{@remote_uri}"
      
    end
    
    # Run the command if @command has been set
    def run_command
      system @command if @command
    end
    
    # Optparse options 
    def parse_options
      ARGV.options do |opts|
        #Set usage banner
        opts.banner = "Usage: deploy-to [options] site_name"
        #Version
        opts.on("-v","--version","Outputs version") { 
          puts "deploy-to: #{DeployTo::VERSION}"
          exit 
        }
        opts.on("-s","--simulate","Simulate only") {
          @dry_run = true
        }
        opts.parse!
      end
    end
    
    # This will check our configuration variables and
    # exit 1 if we can't proceed.
    def parse_config
      
      # Make sure there are site definitions
      if not @config.has_key?('remotes')
        puts "Please add at least one remote definitions to your deploy-to.yml file."
        exit 1
      end
      
      # Check for a site_name.
      if @remote_name.nil?
        puts "Specify which remote you woud like to deploy:\n"
        @config['remotes'].each do |remote_name,remote|
          puts "\s\s*\s" + remote_name + " (#{remote['host']})" + "\n"
        end
        exit 1
      end

      # Make sure the site_name is defined.
      if not @config['remotes'].has_key?(@remote_name)
        puts "There is no definitions for \"#{@remote_name}\" in your deploy-to.yml file."
        exit 1
      end
      
      @remote = @config['remotes'][@remote_name]
      
      get_base # Use the get base method to get the base from the config
      
      # Check that your remote has all the options we need
      if not @remote.has_key?('user') or not @remote.has_key?('host') or not @remote.has_key?('path')
        puts "Your remote: #{@remote_name} must contain user,host, and path"
        exit 1
      end
      
      # Define the URI
      @remote_uri = "#{@remote['user']}@#{@remote['host']}:#{@remote['path']}"
      @remote_uri += "/" if not @remote_uri[-1,1] == "/"
    rescue
      puts "There was a problem parsing your config file"
      exit 1
    end
    
    # Gets the base for the config file
    def get_base
      # See if we need to extend the base_dir
      if @config['base']
        extended_base = File.expand_path(File.join(@real_base, @config['base']))
        if File.directory? extended_base
          @base_dir = extended_base
        else
          puts "Your base directory doesn't exist: #{extended_base}"
          exit 1
        end
      end
    end
    
  end
end