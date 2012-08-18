require 'social_blast/version'
require 'social_blast/twitter'
# require 'social_blast/facebook'
# require 'social_blast/googleplus'

class SocialBlast
  def self.on=(v)
    set('on', v)
  end

  def self.on?
    self.on
  end

  def self.posting_count=(v)
    
  end

  def self.threshold_reached?

  end

  def self.can_post?
    on? and not threshold_reached?
  end

  #

  def initialize(msg)

  end

  def deliver

  end

  private

  def self.on
    on = get('on')
    (on.nil? || on) ? true : false
  end

  def self.rails?
    Kernel.const_defined?('Rails')
  end

  def self.set(name, val)
    if rails?
      Rails.cache.write(name, val)
    else
      instance_variable_set("@#{name}".to_sym, val)
    end
  end

  def self.get(name)
    if rails?
      Rails.cache.fetch(name)
    else
      instance_variable_get("@#{name}".to_sym)
    end
  end

  def set(name, val)
    self.class.set(name, val)
  end

  def get(name)
    self.class.get(name)
  end
end

