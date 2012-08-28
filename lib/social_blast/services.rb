require 'social_blast/services/twitter_service'
# require 'social_blast/services/facebook_service'
# require 'social_blast/services/googleplus_service'
# require 'social_blast/services/wordpress_service'
# require 'social_blast/services/linkedin_service'
# require 'social_blast/services/tumblr_service'
# require 'social_blast/services/foursquare_service'

class SocialBlast
  class Services
    def self.services_available
      self.constants.select { |c| self.const_get(c).class == Class }
    end
  end
end

