require 'buff'
require 'time'
require 'thresholdable'
require 'social_blast/config'

class ServiceThreshold < Object
  include ::Thresholdable
end

class SocialBlast
  class Services
    class BufferService < SocialBlast::BaseService
      attr_reader :message

      SERVICE_AUTH_KEYWORDS = %w[ access_token ]

      def self.service_auth_keywords
        SERVICE_AUTH_KEYWORDS
      end

      #

      def initialize(message)
        super(message)
      end

      def deliver
        initialize_service_settings
        if profile_ids.any?
          buffer_client.create_update(request_data)
        end
      rescue Exception => e
        raise DeliveryException, e.message
      ensure
        postable_profiles.each do |p|
          if @service_counter.key? p.service
            @service_counter[p.service].increment_post_count
          end
        end
      end

      #

      private

      def buffer_client
        @buffer_client ||= Buff::Client.new(app_config[:access_token])
      end

      def buffer_client_profiles
        @buffer_client_profile ||= buffer_client.profiles
      rescue Exception => e
        raise DeliveryException, e.message
      end

      def postable_profiles
        @postable_profiles ||= buffer_client_profiles.select do |p|
          if threshold_exists_for(p.service)
            @service_counter[p.service].can_post?
          else
            true
          end
        end
      end

      def profile_ids
        @profile_ids ||= postable_profiles.collect { |p| p.id }
      end

      def profile_services
        buffer_client_profiles.collect { |p| p.service }
      end

      def config_for(service_name)
        app_config[service_name]
      end

      def config_exists_for(service_name)
        app_config.key? service_name
      end

      def threshold_exists_for(service_name)
        config_exists_for(service_name) &&
          app_config[service_name].key?(:threshold)
      end

      def time_ahead(mins)
        (Time.now + (mins * 60)).utc.iso8601
      end

      def request_data
        req_data = {
          body: {
            text: @message,
            profile_ids: profile_ids
          },
          shorten: false
        }
        if app_config[:post_ahead_mins] && app_config[:post_ahead_mins].nonzero?
          req_data[:scheduled_at] = time_ahead app_config[:post_ahead_mins]
        else
          req_data[:now] = true
        end

        req_data
      end

      def initialize_service_settings
        @service_counter = {}
        profile_services.each do |s|
          if config_exists_for s
            @service_counter[s] = ServiceThreshold.new
            @service_counter[s].threshold = config_for(s).threshold
          end
        end
      end

    end
  end
end

