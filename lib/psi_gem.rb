module PSIGEM

# Create our Object
RemoteClient = Struct.new(:ip, :username)

 class Push

    def self.deploy(ignorekeygen = false)

        # Array for Result 
        lstArray = Array.new

        # Generate Public/Private Key (but ignore if desired)
        if ignorekeygen
            generateKey 
        end

        # Get Hosts and Push Key
        lstArray = getHosts

        # SSH-Copy Id
        lstArray.each do |client|
            copyKey client.ip, client.username.strip!
        end

        # Confirmation
        puts "Done"
 
    end

   private
    # This will generate our initial key
    def self.generateKey 
       system "ssh-keygen"     
    end

    # This will copy the key to the desired host
    def self.copyKey (ip, username)
        
        puts "Connecting to #{ip} with User -> #{username}....."

        # Magic Command - the mirror to ssh-copy-id
        system "cat ~/.ssh/id_rsa.pub | ssh #{username}@#{ip} 'mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys'"
    end

    # Will get the hosts we want to deploy the public key too
    def self.getHosts

       file = "config.lst"
       if File.exist?(file)
            lstArray = File.readlines(file).map do |line|
            # Used ";" to avoid \t (TAB) which is different across OS'es
            RemoteClient.new( *line.split("\;") )
            end
        end
       
    end

 end

end
