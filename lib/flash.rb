require 'json'
require_relative 'flash_now'

class Flash

  def initialize(req)
    flash = req.cookies["flash"]
    if flash
      flash_parse = JSON.parse(flash)
      flash_parse.each { |k, v| now[k.to_sym] = v }
    end
    @flash = {}
  end

  def now
    @flash_now ||= FlashNow.new
  end

  def [](key)
    self.now[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    flash = { path: "/", value: @flash.to_json }
    res.set_cookie("flash", flash)
  end
end
