require 'social_blast/version'
# require 'social_blast/twitter'
# require 'social_blast/facebook'
# require 'social_blast/googleplus'

class SocialBlast
  def self.on=(v)
    @on = v
  end

  def self.on?
    self.on
  end

  def initialize(msg)

  end

  def deliver

  end

  private

  def self.on
    (@on.nil? || @on) ? true : false
  end
end

