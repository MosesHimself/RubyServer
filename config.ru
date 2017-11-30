# config.ru
require 'rack'
require 'rack/builder'
require 'rack/lobster'
#require './test_server'

use Rack::Lint # gives more descriptive error messages when responses aren't valid

class Example
  def initialize(app)
    @app = app
  end
  def call(env)
    status, headers, body = @app.call(env)
    body.map { |msg| p "Example: #{msg}" }
    [status, headers, body]
  end
end
use Example # Does nothing with uppercase'd response, just logs it to stdout
run -> env {[200, {"Content-Type" => "text/html"}, ["<h1>Hello Redpanthers</h1>"]]}
