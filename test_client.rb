require 'socket'
require "./CONFIG"

Thread.abort_on_exception = true

username = ARGV[0]
password = ARGV[1]

file = File.read("./credentials.txt")
if !file["#{username}:#{password}"]
  puts 'Improper username or password!'
  exit 1
end

puts "Connecting to #{HOST} on port #{PORT}..."

client = TCPSocket.open(HOST, PORT)

puts 'Logged in to chat server, type away!'
puts "Use 'CTRL+C' to logout!"
puts "'ENTER' to send!"
puts "Use '(username) message' to specify a message recipent!"

client.puts username

Thread.new do
  while line = client.gets
    puts line.chop
  end
end

while input = STDIN.gets.chomp
  client.puts input
end
