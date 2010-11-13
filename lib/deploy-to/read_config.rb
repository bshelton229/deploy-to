#Read the config File
module DeployTo
  class Config
    def self.get_config
      #Return what we have if we've already loaded the config file
      return @options if @options

      #Search for the config file, start at PWD and go backwards
      file = self.config_file
    
      #Load the YAML
      @options = YAML::load(File.open(file))
    end
    
    #Find the config file and set @config_file
    def self.config_file
      @config_file ||= self.lookfor(Dir.pwd)
    end
  
    private
    #Recursively look for the config file
    def self.lookfor(path)
      #Get out of here if we're at root (/)
      if path == "/"
        puts "Can't find a deploy-to.yml file."
        exit 1
      end
    
      #Define the file given the path
      file = File.join(path,'deploy-to.yml')
      if File.exists? file
        return file
      else
        # We didn't find a file, recurse the path
        # backwards and try again
        self.lookfor(File.expand_path('../',path))
      end
    end
  end
end
