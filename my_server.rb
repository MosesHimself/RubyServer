require 'socket'
require 'rack'
require 'sinatra'
require 'uri'
require "./CONFIG"

# Simple, rack-compliant web server
class MyServer

  # these here are symbols
  # attr_reader makes these attributes, aka readable from outside
  attr_reader :app, :server

  def initialize(app)
    @app = app
  end

  def start

    @server = TCPServer.new PORT
    STDERR.puts "Listening on #{PORT}..."

    loop do

      # when the server receives a request
      Thread.fork(server.accept) do |session|
        STDERR.puts "Starting Thread."
        if (request_line = session.gets) != "\r\n"
          STDERR.puts request_line

          #if request_line != "GET /favicon.ico HTTP/1.1\r\n"
            env = new_env(request_line)
            STDERR.puts "New env made. Calling app now!"
            status, headers, body = app.call(env)
          #end

          if path = requested_file(request_line)
            path = File.join(path, 'index.html') if File.directory?(path)

            if File.exist?(path) && !File.directory?(path)
              File.open(path, "rb") do |file|

                # response line
                session.print "HTTP/1.1 #{status}\r\n"

                # headers
                if headers
                  headers.each do |key, value|
                    session.print "#{key}: #{value}\r\n"
                  end
                end
                session.print "\r\n"

                # body
                if body
                  body.each do |part|
                    session.print part
                  end
                end

                IO.copy_stream(file, session)
              end
            else
              error = "File not found!\n"
              # respond with a 404 error code to indicate the file does not exist
              session.print "HTTP/1.1 404 Not Found\r\n" +
                            "Content-Type: text/plain\r\n" +
                            "Content-Length: #{message.size}\r\n" +
                            "Connection: close\r\n"
              session.print "\r\n"
              session.print error
            end
          end
        else

        end
        STDERR.puts "Closing Thread."
        session.close
      end
    end
  end


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

# Rack needs to know how to start the server
module Rack
  module Handler
    class MyServer
      def self.run(app, options = {})
        server = ::MyServer.new(app)
        STDERR.puts 'Starting server...'
        server.start
      end
    end
  end
end
Rack::Handler.register('my_server', 'Rack::Handler::MyServer')
