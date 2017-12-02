require './test'

class ChatRoom < AppServer

  def initialize(app)
    super()
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    @session = @request.session
    STDERR.puts 'made a request'

    mkPath('POST','/account/create', location: "/account/login") do
      STDERR.puts 'made a request to account/create'
    end

    mkPath('POST','/account/delete', location: "/account/create.html") do
      STDERR.puts 'made a request to account/delete'
    end

    mkPath('POST','/account/login', location: "/account") do
      STDERR.puts 'made a request to account/login'
    end

    mkPath('GET','/account/logout') do
      STDERR.puts 'made a request to account/logout'
    end

    mkPath('POST','/account') do
      @request.post?
      if @request.params["username"]
        @request.body.map { |msg| p "Example: #{@request.params["username"]}" }
      end
    end

    mkPath('POST','/chatroom/send') do
      STDERR.puts 'made a request to send'
    end

    mkPath('POST','/chatroom/send2') do
      STDERR.puts 'made a request to send2'
    end

    mkPath('GET','/chatroom/who') do
      STDERR.puts 'made a request to who'
    end

    mkPath('GET','/chatroom') do
      STDERR.puts 'made a request to chatroom'
    end

    path_info = formPath(env)
    go(path_info, env)

  end



end
