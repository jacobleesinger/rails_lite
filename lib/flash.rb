require 'rack'
require 'byebug'
require 'json'

class Flash
  attr_reader :flashed, :flash
  def initialize(req)
    if req.cookies["_rails_lite_app"]
      @flash = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @flash = {}
    end
  end

  def [](key)
    @flash[key.to_s]
  end

  def []=(key, val)
    @flash[key.to_s] = val
  end

  def now
    @now ||= FlashNow.new(self)
    @now.flash
    # debugger
  end

  def flashed?
    @flashed ||= false
    flashed
  end

  def store_flash(res)
    cookie = flash.to_json
    res.set_cookie("_rails_lite_app", {path: '/', value: cookie})
  end
end

class FlashNow
  def initialize(flash)
    # debugger
    @flash = flash
  end

  def flash
    @flash.flash
  end
end
