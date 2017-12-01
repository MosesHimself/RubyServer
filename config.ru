# config.ru

require './test'
require './my_server'
require 'rack'
require 'rack/builder'
require 'rack/lobster'

app = Rack::Builder.app do
  use SomeMiddleware
  #run Rack::Lobster.new
  use Rack::Handler::MyServer.run(lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Heres the body']] })
end

run app
