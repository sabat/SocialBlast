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

  def self.posting_count=(v)
    
  end

  def self.posting_threshold_reached?

  end

  def self.can_post?
    on? and not posting_threshold_reached?
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

