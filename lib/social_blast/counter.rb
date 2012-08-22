class Counter
  include ShmStore

  def reset
    set_val('timestamp', DateTime.now)
    set_val('counter', 0) 
  end

  def value
    val = get_val('counter')
    val.nil? ? reset : val
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

end

