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
      #Find our base dir
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

    #Define the command to run
    def build_command
      
      #Define the excludes
      excludes = Array.new
      
      if(@config.has_key?('ignore'))
        if not @config['ignore'].empty?
          @config['ignore'].each do |ignore|
            excludes << "--exclude \'#{ignore}\'"
          end
        end
      end
      
      if not excludes.empty?
        exclude_cli = excludes.join(' ')
      else
        exclude_cli = ''
      end
      
      # If we're in a dry run, set the rsync option
      dry_run = @dry_run ? ' --dry-run' : ''
      
      # Define the command
      @command = "#{@rsync} -aiz --no-t --no-p --size-only --delete#{dry_run} --exclude '.git' --exclude '.svn' --exclude '.gitignore' --exclude 'deploy-to.yml' #{exclude_cli} #{@base_dir}/ #{@remote_uri}"
      
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
          puts "Production Sync - #{DeployTo::VERSION}"
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
        @config['remotes'].each do |remote|
          puts remote[0] + "\n"
        end
        exit 1
      end

      # Make sure the site_name is defined.
      if not @config['remotes'].has_key?(@remote_name)
        puts "There is no definitions for \"#{@remote_name}\" in your deploy-to.yml file."
        exit 1
      end
      
      @remote = @config['remotes'][@remote_name]
      
      # Check that your remote has all the options we need
      if not @remote.has_key?('user') or not @remote.has_key?('host') or not @remote.has_key?('path')
        puts "Your remote: #{@remote_name} must contain user,host, and path"
        exit 1
      end
      
      # Define the URI
      @remote_uri = "#{@remote['user']}@#{@remote['host']}:#{@remote['path']}"
      @remote_uri += "/" if not @remote_uri[-1,1] == "/"
    rescue
      puts "There was a problem parsing yoru config file"
      exit 1
    end
    
  end
end