module DeployTo
  class PostCommands
    
    # Run the post commands, if dry_run = true
    # the commands that would be run as simply displayed
    def self.run_commands(remote,dry_run=true)
      if remote['post_commands']
        commands = remote['post_commands']
        # Convert to an array if it's not already
        commands = Array.new << commands if not commands.kind_of?(Array)
        
        uri = build_uri(remote)
        
        puts "* Running post commands\n"
        
        # Iterate through the commands and run them 
        commands.each do |command|
          if not dry_run
            puts "Running \"#{command}\"\n"
            system "ssh #{uri} 'cd #{remote['path']}; #{command}'"
          else
            puts "Would run \"#{command}\""
          end
        end
        
      end
    end
    
    private
    
    # Build the URI
    def self.build_uri(remote)
      "#{remote['user']}@#{remote['host']}"
    end
    
  end
end
