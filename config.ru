# config.ru

require './color'
require './my_server'
require 'rack'
require 'rack/builder'
require 'rack/handler'

app = Rack::Builder.app do
  use Rack::Handler::MyServer.run(
        Color.new( lambda { |env|
          [200, {'Content-Type' => 'text/html'},[]] }
        )
      )
end

run app
