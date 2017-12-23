require 'socket'
require './processes'
require "./CONFIG"

Thread.abort_on_exception = true

puts "Starting server on port #{PORT} with pid #{Process.pid}"

server = TCPServer.open(PORT)
cWriters = []
users = []
mReader, mWriter = IO.pipe

writeToProcesses(mReader, cWriters)

loop do
  while socket = server.accept

    cReader, cWriter = IO.pipe
    cWriters.push(cWriter)

    username = read(socket)
    users.push(username)
    # Fork child process, everything in the fork block only runs in the child process
    fork do
      puts "#{Process.pid}: Accepted connection from #{username}"

      writeToClient(username, cReader, socket)

      # Read incoming messages from the client.
      while message = read(socket)
        time = Time.new
        year = time.year    # => Year of the date
        month = time.month   # => Month of the date (1 to 12)
        day = time.day     # => Day of the date (1 to 31 )
        hour = time.hour    # => 23: 24-hour clock
        min = time.min     # => 59
        sec = time.sec     # => 59
        #at #{hour}:#{min} on #{day}/#{month}/#{year}:

        #if else tree for the incoming message from client to server
        if message.start_with?("(WHO)")
          message = ''
          users.each do |usr|
            message += "#{usr} "
          end
          mWriter.puts "/#{username}(WHO): #{message} are in the chat!"
          puts "#{username}(WHO): #{message} are in the chat!"
        else
          if message.start_with?("(")
            
          else
            mWriter.puts "#{username}: #{message}"
            puts "#{username}: #{message}"
          end
        end


      end

      puts "#{Process.pid}: Disconnected #{username}"
      mWriter.puts "#{username} has disconnected!"
    end

  end
end
