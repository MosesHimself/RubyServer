# Ruby Server

This is a side project of mine that is currently under development.
I am working on building a full framework that will allow for Ruby apps to run on the web.
All together, this program uses the Rack specification(found through out the program but begins in config.ru) to allow the various pieces to fit together and make sure all application layers added can interface properly.
Currently I have made a file server(found in my_server.rb) that will respond to most HTTP requests like GET, HEAD, POST, etc. All accessible web pages are located in the public file and no client can access any other directories. I still have to add multithreading to allow for multiple clients to access the server at one time though.
Connecting this web server and a potential ruby app is the app server I created(found in test.rb). This uses a protocol that takes the first line of the HTTP request and will use the method and path to locate a certain block of ruby code to be ran. These ruby code block reside in any class that inherits from the App Server class, such as the class found in chatroom.rb. To initialize these ruby blocks, just use the mkPath method as follows
`mkPath('POST','/chatroom/send') do
  # put your code here
end`
