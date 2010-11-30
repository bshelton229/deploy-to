#Read the config File
module DeployTo
  class Config
    class << self
      attr_reader :config_file, :options

      def get_config
        #Return what we have if we've already loaded the config file
        return @options if @options

        #Search for the config file, start at PWD and go backwards
        file = get_config_file
  
        #Load the YAML
        @options = YAML::load(File.open(file))
      end

      private
      
      #Find the config file and set @config_file
      def get_config_file
        @config_file ||= lookfor(Dir.pwd)
      end
      
      #Recursively look for the config file
      def lookfor(path)
        #Define the file given the path
        file = File.join(path,'deploy-to.yml')
        if File.exists? file
          return file
        else
          back = File.expand_path('../',path)
          if not path.eql?(back)
            lookfor(back)
          else
            puts "Can't find a deploy-to.yml file."
            exit 1
          end
        end
      end
  
    end
  end
end
