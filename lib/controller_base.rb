require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './flash'


class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @route_params = route_params
    @params = req.params.merge(route_params)
    @already_built_response = false
  end

  def already_built_response?
      @already_built_response
  end

  def redirect_to(url)
    raise "error" if already_built_response?
    @res['LOCATION'] = url
    @res.status = 302
    @already_built_response = true
    session.store_session(res)
  end

  def render_content(content, content_type)
    raise "error" if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session(res)
  end

  def render(template_name)
    template_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    path_contents = File.read(template_path)
    content = ERB.new(path_contents).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name, csrf)
   if csrf && @protect
     raise "Invalid Authenticity Token" unless same_token?
     self.send(name)
     reset_authenticity_token!
   else
     self.send(name)
   end
   render(name) unless already_built_response?
 end
end
