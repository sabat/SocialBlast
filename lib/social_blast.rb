require 'social_blast/version'
require 'social_blast/shm_store'
require 'social_blast/services'
# require 'social_blast/facebook'
# require 'social_blast/googleplus'

class SocialBlast
  extend ShmStore

  def self.on=(v)
    set_val('on', v)
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
    @msg = msg
    extend ShmStore
  end

  def deliver

  end

  private

  def self.on
    on = get_val('on')
    (on.nil? || on) ? true : false
  end

end

