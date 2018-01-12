
class AppServer

  def initialize
      @paths={}
  end

  def go(pathI, env=nil)
      if ((!@paths.keys.include?(pathI)) && env)
          @app.call(env)
      else
        method = pathI[0]
        url = pathI[1]

        @paths.each do |path, response|
          if (path[0] == method && path[1] == url)
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
      STDERR.puts 'got a redirect fam at' + redirects[:location]
      response.headers["Location"] = redirects[:location]
      response.status = '302'
    end

    @paths[[method, path]] = [response.status, response.headers, [response.body]]
  end

  def formPath(env)
    request = Rack::Request.new(env)
    path = request.path_info
    [request.request_method, path]
  end

end
