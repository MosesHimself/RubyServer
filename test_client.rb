# tcp_client.rb
require 'socket'
server = TCPSocket.new 'localhost', 17714

while line = server.gets
  puts line
end

server.close
