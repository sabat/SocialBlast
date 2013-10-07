require 'buff'

class SocialBlast
  class Services

    class BufferService < SocialBlast::BaseService
      attr_reader :message

      SERVICE_AUTH_KEYWORDS = %w[ access_token ]

      def self.service_auth_keywords
        SERVICE_AUTH_KEYWORDS
      end

      #

      def deliver
        pids = profile_ids
        buffer_client.create_update(
          body: { text: @message },
          profile_ids: pids,
          now: true,
          shorten: false
        )
      rescue Exception => e
        raise DeliveryException, e.message
      end

      #

      private

      def buffer_client
        @buffer_client ||= Buff::Client.new(app_config[:access_token])
      end

      def buffer_client_profiles
        buffer_client.profiles
      rescue Exception => e
        raise DeliveryException, e.message
      end

      def profile_ids
        buffer_client_profiles.collect { |p| p.id }
      end

    end
  end
end

