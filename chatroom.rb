require './test'

class ChatRoom < AppServer

  def initialize(app)
    super()
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    @session = @request.session

    mkPath('POST',’/account/create’) do
    # create account
    # return string
    end
    mkPath('POST',’/account/delete’) do
    # delete user’s account
    # return string
    end

    mkPath('POST',’/account/login’) do
    # login
    # return string
    end

    mkPath('GET',’/account/logout’) do
    # create account
    # return string
    end

    mkPath('POST',’/account’) do
      @request.post?
      if @request.params["username"]
        @request.body.map { |msg| p "Example: #{@request.params["username"]}" }
      end
    end

    mkPath('POST',’/chatroom/send’) do
    # create account
    # return string
    end

    mkPath('POST',’/chatroom/send2’) do
    # create account
    # return string
    end

    mkPath('GET',’/chatroom/who’) do
    # create account
    # return string
    end

    mkPath('GET',’/chatroom’) do
    # create account
    # return string
    end

    path_info = formPath(env)
    go(path_info, env)

  end



end
