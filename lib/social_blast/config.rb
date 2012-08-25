require 'hashie'

class SocialBlast
  class Configuration < Hashie::Mash; end

  def self.configure
    yield self.configuration if block_given?
    self.configuration
  end

  private

  def self.configuration
    @configuration ||= Configuration.new
  end
end

