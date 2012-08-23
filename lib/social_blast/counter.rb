class Counter
  include ShmStore

  DEFAULT_INTERVAL = 60 # minutes

  def reset
    set_val('timestamp', Time.now)
    set_val('counter', 0) 
  end

  def value=(v)
    set_val('counter', v)
  end

  def value
    val = get_val('counter')
    val.nil? ? reset : val
  end

  def timestamp=(v)
    set_val('timestamp', v)
  end

  def timestamp
    val = get_val('timestamp')
    if val.nil?
      reset
      get_val('timestamp')
    else
      val
    end
  end

  def interval=(v)
    @interval = v
  end

  def interval
    @interval || DEFAULT_INTERVAL
  end

  def increment
    if interval_expired?
      reset
    else
      set_val('counter', self.value + 1)
    end
  end

  def to_s
    self.value.to_s
  end

  #

  private

  def minute_difference
    diff = (Time.now - self.timestamp) * 60
    diff.to_i
  end

  def interval_expired?
    minute_difference > self.interval
  end

end

