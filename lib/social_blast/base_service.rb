class SocialBlast
  class BaseService

    attr_reader :message

    def self.service_name
      @service_name ||= self.name.split(/::/).last.to_sym
    end

    def self.short_name
      @short_name ||= self.service_name.to_s.sub(/Service$/, '').downcase
    end

    def self.short_name_sym
      @short_name_sym ||= short_name.to_sym
    end

    def self.configured?
      service_auth_keywords.all? do |k|
        app_config[k].present? && app_config[k].kind_of?(String)
      end
    end

    #

    def initialize(message)
      raise NotConfiguredException unless self.class.configured?
      raise ArgumentError, 'cannot be nil or empty' if !message.present?
      @message = message
    end

    def service_name
      self.class.service_name
    end

    def short_name
      self.class.short_name
    end

    def short_name_sym
      self.class.short_name_sym
    end

    #

    private

    def self.app_config
      @app_config ||= SocialBlast.configure[short_name_sym]
    end

    def app_config
      self.class.app_config
    end

  end
end

