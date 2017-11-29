# test_server.rb
require 'socket'
require 'rack'
require 'rack/lobster'
load "CONFIG.rb"

app = Rack::Lobster.new
server = TCPServer.new 17714

# when the server receives a request
while session = server.accept
  request = session.gets
  puts request

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
    'SERVER_NAME' => 'localhost',
    'SERVER_PORT' => '17714',
    'REMOTE_ADDR' => '127.0.0.1',
    'rack.version' => [1,3],
    'rack.input' => input,
    'rack.errors' => $stderr,
    'rack.multithread' => false,
    'rack.multiprocess' => false,
    'rack.run_once' => false,
    'rack.url_scheme' => 'http'
  })
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
  end
  session.close
end
