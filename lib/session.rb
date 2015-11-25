require 'json'



class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies["_rails_lite_app"]
      @cookie_value_hash = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @cookie_value_hash = {}
    end
  end

  def [](key)
    @cookie_value_hash[key]
  end

  def []=(key, val)
    @cookie_value_hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    cookie = @cookie_value_hash.to_json
    res.set_cookie("_rails_lite_app", {path: '/', value: cookie})
  end
end
