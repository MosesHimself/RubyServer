# test_server.rb
require 'socket'
require 'uri'
require 'rack'
require 'rack/lobster'
require "./CONFIG"
require 'sinatra'

module Emerald

  class WebServer

    attr_reader :app, :server

    def initialize(app)
      @routes={}
      @app = app
    end

    def content_type(path)
      ext = File.extname(path).split(".").last
      CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
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

    def start
      @server = TCPServer.new PORT

      # when the server receives a request
      while session = server.accept

        request = request_line = session.gets
        STDERR.puts request_line

        env = new_env(request)
        status, headers, body = app.call(env)

        path = requested_file(request_line)
        if File.exist?(path) && !File.directory?(path)

          File.open(path, "rb") do |file|

            # response line
            session.print "HTTP/1.1 #{status}\r\n"
            # headers
            headers.each do |key, value|
              session.print "#{key}: #{value}\r\n"
            end
            session.print "\r\n"

            if method != "HEAD"
              body.each do |part|
                session.print part
              end
              IO.copy_stream(file, session)
            end
          end
          session.close
        end
      end
    end

    def new_env(request)
      # split the method and path
      method, full_path = request.split(' ')
      # split path even further
      path, query = full_path.split('?')

      input = StringIO.new
      input.set_encoding 'ASCII-8BIT'

      # pass these shits into the rack environment hash
      status, headers, body = app.call({
        'REQUEST_METHOD' => method,
        'PATH_INFO' => path,
        'QUERY_STRING' => query || '',
        'SERVER_NAME' => HOST,
        'SERVER_PORT' => PORT,
        'REMOTE_ADDR' => '127.0.0.1',
        'rack.version' => [1,3],
        'rack.input' => input,
        'rack.errors' => $stderr,
        'rack.multithread' => false,
        'rack.multiprocess' => false,
        'rack.run_once' => false,
        'rack.url_scheme' => 'http'
      })
    end
  end #class
end #module

# Rack needs to know how to start the server
module Rack
  module Handler
    class WebServer
      def self.run(app, options = {})
        server = Emerald::WebServer.new(app)
        server.start
      end
    end
  end
end
Rack::Handler.register('web_server', 'Rack::Handler::WebServer')

# Sinatra app
set :server, :web_server

get '/' do
  'Hello world!'
end
