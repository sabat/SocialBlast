require 'hashie'
require 'social_blast/services'

class SocialBlast
  class Configuration < Hashie::Mash; end

  class << self
    def configure
      yield self.configuration if block_given?
      self.configuration
    end

    alias :config :configure
  end

  private

  def self.configuration
    @configuration ||= begin
      c = Configuration.new
      SocialBlast::Services.services_available(:short).each do |s|
        c[s] = Hashie::Mash.new
      end
      c
    end
  end
end

