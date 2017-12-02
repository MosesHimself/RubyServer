# config.ru

require './chatroom'
require './my_server'
require 'rack'
require 'rack/builder'
require 'rack/handler'

app = Rack::Builder.app do
  use ChatRoom
  use Rack::Handler::MyServer.run(lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Heres the body']] })
end

run app
