require 'debugger'
require 'social_blast/version'
require 'social_blast/shm_store'
require 'social_blast/object'
require 'social_blast/counter'
require 'social_blast/services'
# require 'social_blast/facebook'
# require 'social_blast/googleplus'

class SocialBlast
  extend ShmStore
  include ShmStore

  attr_reader :message

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

  def initialize(message)
    raise ArgumentError, 'cannot be empty' if message.blank?
    @message = message
    @services = []
  end

  def add_service(service)
    if have_service?(service) and configured?(service)
      @services << service_class(service).new(self.message)
    end
  end

  def deliver
    if SocialBlast.on
      @services.each { |s| s.deliver }
    else
      false
    end
  end

  def delivering_to
    @services.collect { |s| s.name }
  end

  #

  private

  def self.on
    on = get_val('on')
    (on.nil? || on) ? true : false
  end

  def self.reset_counter
    set_val('counter_timestamp', DateTime.now)
    set_val('counter', 0)
  end

  def self.counter
    counter_val = get_val('counter')
    counter_val.nil? ? reset_counter : counter_val
  end

  def self.services_available
    self::Services.constants.select { |c| self::Services.const_get(c).class == Class }
  end

  def services_available
    self.class.services_available
  end

  def have_service?(service)
    services_available.include?(service)
  end

  def service_class(service)
    if services_available.include?(service)
      self.class::Services.const_get(service)
    end
  end

  def configured?(service)
    service_class(service).configured?
  end

end

