require 'social_blast/version'
require 'thresholdable'
require 'social_blast/object'
require 'social_blast/config'
require 'social_blast/exceptions'
require 'social_blast/services'

class SocialBlast
  extend Thresholdable

  attr_reader :message

  class << self
    def on=(v)
      set_val('on', v)
    end
  
    def on?
      self.on
    end

    def services_available
      self::Services.services_available
    end
  end

  #

  def self.can_post?
    on? && super
  end

  def initialize(message)
    raise ArgumentError, 'cannot be empty' if message.blank?
    @message = message
    @services = []
  end

  def add_service(service)
    if have_service?(service) and configured?(service) and !delivering_to.include? service
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
      @services.each(&:deliver)
      SocialBlast.increment_post_count
    else
      raise PostingDisabledException
    end
  end

  def delivering_to
    @services.collect { |s| s.service_name }
  end

  def all_services
    self.class::Services.services_available(:configured).each do |s|
      self.add_service s
    end
    self
  end

  #

  private

  def self.on
    on = get_val('on')
    (on.nil? || on) ? true : false
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

