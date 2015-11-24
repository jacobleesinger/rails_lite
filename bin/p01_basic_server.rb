require 'rack'

# Rack::Server.start(
#   app: Proc.new { |env| ['200', {Content-Type => 'text.html'}, ['hello world']] }
# )

app = Proc.new do |env|
  req = Rack::Request.new(env)
  food = req.params["food"]
  res = Rack::Response.new(['food'])
  res['Content-Type'] = 'text/html'
  res.write(food)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
