class FlashNow

  def initialize
    @now = {}
  end

  def [](key)
    @now[key]
  end

  def []=(key, val)
    @now[key] = val
  end
end
