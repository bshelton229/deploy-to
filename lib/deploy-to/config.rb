#Read the config File
module DeployTo
  class Config
    class << self
      def get_config
        #Return what we have if we've already loaded the config file
        return @options if @options

        #Search for the config file, start at PWD and go backwards
        file = self.config_file
    
        #Load the YAML
        @options = YAML::load(File.open(file))
      end
    
      #Find the config file and set @config_file
      def config_file
        @config_file ||= lookfor(Dir.pwd)
      end
  
      private

      #Recursively look for the config file
      def lookfor(path)
        #Define the file given the path
        file = File.join(path,'deploy-to.yml')
        if File.exists? file
          return file
        else
          back = File.expand_path('../',path)
          if not path.eql?(back)
            self.lookfor(back)
          else
            puts "Can't find a deploy-to.yml file."
            exit 1
          end
        end
      end
    
    end
  end
end
