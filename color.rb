require './test'

class Color < AppServer

  def initialize(app)
    super()
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    #@session = @request.session
    STDERR.puts 'made a request from color class'

    makePath('GET','/color/') do
      STDERR.puts 'made a path to account/create'
    end


    path_info = formPath(env)
    go(path_info, env)

  end



end
