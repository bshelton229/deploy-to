module DeployTo
  class PostCommands
    
    def self.run_commands(remote)
      if remote['post_commands']
        commands = remote['post_commands']
        # Convert to an array if it's not already
        commands = Array.new << commands if not commands.kind_of?(Array)
        
        uri = build_uri(remote)
        
        # Iterate through the commands and run them 
        commands.each do |command|
          puts "Running \"#{command}\"\n"
          system "ssh #{uri} 'cd #{remote['path']}; #{command}'"
        end
        
      end
    end
    
    # Build the URI
    def self.build_uri(remote)
      "#{remote['user']}@#{remote['host']}"
    end
    
  end
end
