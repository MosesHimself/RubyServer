require 'socket'
require "./CONFIG"
require "uri"

module Emerald
  class Server

    def initialize
      #instance variables
      puts "creating new server yall.."
      @server = TCPServer.new(HOST, PORT)
      @state = 0
    end

    def start
      puts "Starting server!"
      @state = 1
      self.run
    end

    def run
      while @state == 1

        thread = Thread.start(@server.accept) do |socket|

          if (requestLine = socket.gets) != "\r\n"
            begin
              puts requestLine
              #starting our response
              method = requestLine.split(" ")[1]

              path = requested_file(requestLine)
              path = File.join(path, 'index.html') if File.directory?(path)

              if File.exist?(path) && !File.directory?(path)
                File.open(path, "rb") do |file|
                  puts "We got a file!"
                  socket.print "HTTP/1.1 200 OK\r\n" +
                               "Content-Type: #{content_type(file)}\r\n" +
                               "Content-Length: #{file.size}\r\n" +
                               "Connection: close\r\n"
                  socket.print "\r\n"
                  if method != "HEAD"
                    IO.copy_stream(file, socket)
                  end
                end
              else
                puts "We dont have a file..."
                error = "File not found!\n"
                # respond with a 404 error code to indicate the file does not exist
                socket.print "HTTP/1.1 404 Not Found\r\n" +
                              "Content-Type: text/plain\r\n" +
                              "Content-Length: #{error.size}\r\n" +
                              "Connection: close\r\n"
                socket.print "\r\n"
                socket.print error
              end
            rescue
              puts "We have an error..."
              error = "There has been an internal server error!\n"
              # respond with a 404 error code to indicate the file does not exist
              socket.print "HTTP/1.1 500 Internal Server Error\r\n" +
                            "Content-Type: text/plain\r\n" +
                            "Content-Length: #{error.size}\r\n" +
                            "Connection: close\r\n"
              socket.print "\r\n"
              socket.print error
            end

          end
          socket.close
          puts "..end of thread."
        end
        thread.join
      end
    end

    def stop
      puts "Stopping server!"
      @state = 0
    end

    def content_type(path)
      ext = File.extname(path).split(".").last
      CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
    end

    def requested_file(request)
      uri = request.split(" ")[1]
      path = URI.unescape(URI(uri).path)

      clean = []

      parts = path.split("/")

      parts.each do |part|
        next if part.empty? || part == '.'
        part == '..' ? clean.pop : clean << part
      end

      File.join(WEB_ROOT, *clean)
    end

    def new_env(request)
      if request
        # split the method and path
        method, full_path = request.split(' ')
        # split path even further
        path, query = full_path.split('?')

        input = StringIO.new
        input.set_encoding 'ASCII-8BIT'

        # pass these shits into the rack environment hash
        {
          'REQUEST_METHOD' => method,
          'PATH_INFO' => path,
          'QUERY_STRING' => query || '',
          'SERVER_NAME' => HOST,
          'SERVER_PORT' => PORT,
          'REMOTE_ADDR' => '127.0.0.1',
          'rack.version' => [1,3],
          'rack.input' => input,
          'rack.errors' => $stderr,
          'rack.multithread' => true,
          'rack.multiprocess' => false,
          'rack.run_once' => false,
          'rack.url_scheme' => 'http'
        }
      end
    end
end

end

s = Emerald::Server.new()
s.start
