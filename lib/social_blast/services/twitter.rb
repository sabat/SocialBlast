class SocialBlast
  module Services

    class NotConfiguredException < Exception; end

    class Twitter
      SERVICE_AUTH_KEYWORDS = %w{ consumer_key consumer_secret oauth_token oauth_token_secret }

      def self.configure
        SocialBlast.configure.twitter ||= Hashie::Mash.new
      end

      def self.configured?
        SERVICE_AUTH_KEYWORDS.all? do |key|
          self.configure[key].present? &&
          self.configure[key].kind_of?(String)
        end
      end

      #

      def initialize(message)
        raise NotConfiguredException unless self.class.configured?
        raise ArgumentError, 'cannot be nil or empty' if !message.present?
        @message = message
      end

    end

  end
end

