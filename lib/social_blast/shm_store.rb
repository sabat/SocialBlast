module ShmStore

  def set_val(name, val)
    if rails?
      Rails.cache.write(name, val)
    else
      instance_variable_set("@#{name}".to_sym, val)
    end
    val
  end

  def get_val(name)
    if rails?
      Rails.cache.fetch(name)
    else
      instance_variable_get("@#{name}".to_sym)
    end
  end

  def rails?
    Kernel.const_defined?('Rails')
  end

end

