require 'social_blast/base_service'
require 'social_blast/services/twitter_service'
require 'social_blast/services/buffer_service'
# require 'social_blast/services/facebook_service'
# require 'social_blast/services/googleplus_service'
# require 'social_blast/services/wordpress_service'
# require 'social_blast/services/linkedin_service'
# require 'social_blast/services/tumblr_service'
# require 'social_blast/services/foursquare_service'

class SocialBlast
  class Services
    def self.services_available(opt=nil)
      services = self.constants.select { |c| self.const_get(c).class == Class }
      if opt == :short
        services.collect { |s| const_get(s).short_name_sym }
      elsif opt == :configured
        services.select { |c| self.const_get(c).configured? }
      else
       services
      end
    end
  end
end

