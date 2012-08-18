require 'social_blast/version'
require 'social_blast/twitter'
# require 'social_blast/facebook'
# require 'social_blast/googleplus'

class SocialBlast
  def self.on=(v)
    @on = v
  end

  def self.on?
    self.on
  end

  def self.social_posting_count=(v)
    
  end

  def self.social_posting_threshold_reached?

  end

  #

  def initialize(msg)

  end

  def deliver

  end

  private

  def self.on
    (@on.nil? || @on) ? true : false
  end

  def self.rails?
    Kernel.const_defined?('Rails')
  end
end

