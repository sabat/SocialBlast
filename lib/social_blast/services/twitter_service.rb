require 'twitter'
require 'twitter/error'

class SocialBlast
  module Services

    class TwitterService
      attr_reader :message

      SERVICE_AUTH_KEYWORDS = %w[
          twitter_consumer_key
          twitter_consumer_secret
          twitter_oauth_token
          twitter_oauth_token_secret
      ]

      def self.service_name
        self.name.split(/::/).last.to_sym
      end

      def self.configured?
        SERVICE_AUTH_KEYWORDS.all? do |k|
          SocialBlast.configure[k].present? &&
          SocialBlast.configure[k].kind_of?(String)
        end
      end

      #

      def initialize(message)
        raise NotConfiguredException unless self.class.configured?
        raise ArgumentError, 'cannot be nil or empty' if !message.present?
        @message = message
      end

      def deliver
        begin
          twitter_client.update(@message)
        rescue Twitter::Error => e
          raise DeliveryException, e.message
        end
      end

      #

      private

      def app_config
        service_name = self.class.service_name.to_s.sub(/Service$/, '').downcase
        config = SocialBlast.config.select { |k| k.to_s.match(/#{service_name}_/) }
        Hash[
          config.collect do |k,v|
            k = (k.to_s.sub(/^#{service_name}_/, '')).to_sym
            [k,v]
          end
        ]
      end

      def twitter_client
        @twitter_client ||= Twitter::Client.new(app_config)
      end

    end
  end
end

