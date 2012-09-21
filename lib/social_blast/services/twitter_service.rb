require 'twitter'
require 'twitter/error'

class SocialBlast
  class Services

    class TwitterService < SocialBlast::BaseService
      attr_reader :message

      SERVICE_AUTH_KEYWORDS = %w[
          consumer_key
          consumer_secret
          oauth_token
          oauth_token_secret
      ]

      def self.service_auth_keywords
        SERVICE_AUTH_KEYWORDS
      end

      #

      def deliver
        begin
          twitter_client.update(@message)
        rescue Twitter::Error => e
          raise DeliveryException, e.message
        end
      end

      #

      private

      def twitter_client
        https_proxy = ENV['HTTPS_PROXY'] || ENV['https_proxy']
        Twitter.connection_options[:proxy] = https_proxy
        @twitter_client ||= Twitter::Client.new(app_config)
      end

    end
  end
end

