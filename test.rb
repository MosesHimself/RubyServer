

class AppServer

  def initialize
      @paths={}
  end


  def go(path, env=nil)
      if ((!@paths.keys.include?(route_info)) && env)
          @app.call(env)
      else
        http_method = route_info[0]
        url = route_info[1]

        @paths.each do |path, response|
          if (route[0] == http_method && path[1] == url)
            response[2][0] = response[2][0].call
            return response
          end
        end

        @not_found
      end
    end

  def mkPath(method, path, redirects={}, &code)
    response = Rack::Response.new
    response.body = code

    if redirects[:location]
      response.headers["Location"] = redirects[:location]
      response.status = '302'
    end

    @paths[[http_method, path]] = [response.status, response.headers, [response.body]]
  end

  def formPath(env)
    request = Rack::Request.new(env)
    path = request.path_info
    [method, path]
  end

end
