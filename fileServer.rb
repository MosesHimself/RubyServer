require 'socket'
require 'cgi'
require 'uri'
require 'net/http'
load "CONFIG.rb"

# This helper function parses the extension of the
# requested file and then looks up its content type.

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.

def requested_file(request_line)
  if request_line != nil

    request_uri  = request_line.split(" ")[1]
    path         = URI.unescape(URI(request_uri).path)

    clean = []

    # Split the path into components
    parts = path.split("/")

    parts.each do |part|
      # skip any empty or current directory (".") path components
      next if part.empty? || part == '.'
      # If the path component goes up one directory level (".."),
      # remove the last clean component.
      # Otherwise, add the component to the Array of clean components
      part == '..' ? clean.pop : clean << part
    end

    # return the web root joined to the clean path
    File.join(WEB_ROOT, *clean)
  end
end

# Except where noted below, the general approach of
# handling requests and generating responses is
# similar to that of the "Hello World" example
# shown earlier.

server = TCPServer.new(HOST, PORT)

loop do
  Thread.start(server.accept) do |client|
    request_line = client.gets
    STDERR.puts request_line

    path = requested_file(request_line)
    path = File.join(path, 'index.html') if File.directory?(path)

    # Make sure the file exists and is not a directory
    # before attempting to open it.
    if File.exist?(path) && !File.directory?(path)
      begin
        File.open(path, "rb") do |file|
          client.print "HTTP/1.1 200 OK\r\n" +
                       "Content-Type: #{content_type(file)}\r\n" +
                       "Content-Length: #{file.size}\r\n" +
                       "Connection: close\r\n"

          client.print "\r\n"

          # write the contents of the file to the client
          if request_line["GET"] || request_line["POST"]

            IO.copy_stream(file, client)
          end
        end
      rescue
        client.print "HTTP/1.1 500 Internal Server Error\r\n" +
                     "Content-Type: text/plain\r\n" +
                     "Content-Length: #{file.size}\r\n" +
                     "Connection: close\r\n"

        client.print "\r\n"
      end
    else
      # respond with a 404 error code to indicate the file does not exist
      client.print "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{message.size}\r\n" +
                   "Connection: close\r\n"

      client.print "\r\n"

      message = "File not found\n"
      client.print message
    end

  client.close
end
