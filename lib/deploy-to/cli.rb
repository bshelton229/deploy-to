require 'optparse'

module DeployTo
  class CLI
    
    attr_reader :config, :rsync

    def initialize
      @config = DeployTo::Config.get_config
      @command = false
      @rsync = `which rsync`.chop
      #Find our base dir
      @base_dir = File.expand_path('../',DeployTo::Config.config_file)
      #Parse the CLI options with optparse
      parse_options
      
      #Set what will not be @site_name after running optparse
      @site_name = ARGV.shift
      
      # Parse the config file and the @site_name
      # to see if we should continue. This method will exit1
      # if there are any problems.
      parse_config
    
    end
    
    # Run the command
    def run
      build_command
      puts @command
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
      
      
      #Define the command
      @command = "#{@rsync} -avz --delete --exclude '.git' --exclude '.svn' --exclude '.gitignore' #{exclude_cli} #{@base_dir}/ #{@site_uri}"
      
    end
    
    #Run the command if @command has been set
    def run_command
      system @command if @command
    end
    
    #Optparse options
    def parse_options
      ARGV.options do |opts|
        #Version
        opts.on("-v","--version","Outputs version") { 
          puts "Production Sync - #{DeployTo::VERSION}"
          exit 
        }
        opts.parse!
      end
    end
    
    # This will check our configuration variables and
    # exit 1 if we can't proceed
    def parse_config
      if @site_name.nil?
        puts "Please provide a site name to deploy\ndeploy-to site_name"
        exit 1
      end
      
      if not @config.has_key?('sites')
        puts "Please add site definitions to your deploy-to.yml file."
        exit 1
      end
      
      if not @config['sites'].has_key?(@site_name)
        puts "There is no definitions for \"#{@site_name}\" in your deploy-to.yml file."
        exit 1
      end
      
      @site = @config['sites'][@site_name]
      @site_uri = "#{@site['user']}@#{@site['host']}:#{@site['path']}"
      
    end
    
  end
end