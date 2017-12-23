
def writeToProcesses(mReader, cWriters)
  Thread.new do
    while message = mReader.gets
      cWriters.each do |writer|
        writer.puts message
      end

    end
  end
end

def writeToClient(username, cReader, socket)
  Thread.new do
    while message = cReader.gets
      puts username
      if message.start_with?("/#{username}(WHO):")
        socket.puts message + ":who"
      else
        if message.start_with?(username)

          socket.puts "Message sent!"
        else
          if message.start_with?("/")
          else
            socket.puts message
          end
        end
      end
    end
  end
end

def read(socket)
  if read = socket.gets
    read.chomp
  end
end
