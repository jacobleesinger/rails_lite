require 'rack'

# Rack::Server.start(
#   app: Proc.new { |env| ['200', {Content-Type => 'text.html'}, ['hello world']] }
# )

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  RackApp.new(req, )
  res.finish
end


class RackApp
  def self.call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    res.write("hello")
    res.finish
  end
end

Rack::Server.start(
  app: RackApp,
  Port: 3000
)
