require 'hashie'

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
    @configuration ||= Configuration.new
  end
end

