class SomeMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    body.map { |msg| p "Example: #{msg}" }
    headers["Content-Length"] = body.length.to_s
    [status, headers, body]

  end
end
