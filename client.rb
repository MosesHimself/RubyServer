require 'socket'
socket = TCPSocket.new 'localhost', 4200

while line = socket.gets
  puts line
end

socket.close
