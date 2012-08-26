require 'debugger'
require 'social_blast/version'
require 'social_blast/shm_store'
require 'social_blast/object'
require 'social_blast/config'
require 'social_blast/counter'
require 'social_blast/exceptions'
require 'social_blast/services'
require 'social_blast/string'

class SocialBlast
  extend ShmStore
  include ShmStore

  attr_reader :message

  DEFAULT_THRESHOLD = 3

  class << self
    def on=(v)
      set_val('on', v)
    end
  
    def on?
      self.on
    end
  
    def threshold=(v)
      @threshold = v
    end
  
    def threshold
      @threshold ||= ( config.threshold || DEFAULT_THRESHOLD )
    end

    def post_counter
      @post_counter ||= Counter.new
    end

    def reset_post_count
      post_counter.reset
    end

    def increment_post_count
      post_counter.increment
    end

    def threshold_reached?
      post_counter.value >= self.threshold
    end

    def can_post?
      on? and not threshold_reached?
    end
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

  def remove_service(service)
    if have_service?(service)
      @services.delete_if { |s| s.service_name == service }
    end
  end

  def deliver
    if SocialBlast.on
      raise PostThresholdException if SocialBlast.threshold_reached?
      @services.each { |s| s.deliver }
      SocialBlast.increment_post_count
    else
      raise PostingDisabledException
    end
  end

  def delivering_to
    @services.collect { |s| s.service_name }
  end

  #

  private

  def self.on
    on = get_val('on')
    (on.nil? || on) ? true : false
  end

  def self.services_available
    self::Services.constants.select { |c| self::Services.const_get(c).class == Class }
  end

  def have_service?(service)
    SocialBlast.services_available.include?(service)
  end

  def service_class(service)
    if SocialBlast.services_available.include?(service)
      self.class::Services.const_get(service)
    end
  end

  def configured?(service)
    service_class(service).configured?
  end

end

