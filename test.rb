
class AppServer

  def initialize
      @paths={}
  end

  def go(pathRoute, env=nil)
      if ((!@paths.keys.include?(pathRoute)) && env)
          #STDERR.puts env
          @app.call(env)
      else
        method = pathRoute[0]
        url = pathRoute[1]

        @paths.each do |path, response|
          if (path[0] == method && path[1] == url)
            response[2][0] = response[2][0].call
            return response
          end
        end

        @not_found
      end
    end

  #this function puts the code block into the path array and can be accessed by
  # the method and path
  def makePath(method, path, redirects={}, &code)
    response = Rack::Response.new
    response.body = code

    if redirects[:location]
      STDERR.puts 'got a redirect fam at' + redirects[:location]
      response.headers["Location"] = redirects[:location]
      response.status = '302'
    end

    @paths[[method, path]] = [response.status, response.headers, [response.body]]
  end

  #this just returns the method and path in a tuple
  def formPath(env)
    request = Rack::Request.new(env)
    if request.path_info
      path = request.path_info
      [request.request_method, path]
    end
  end

end
