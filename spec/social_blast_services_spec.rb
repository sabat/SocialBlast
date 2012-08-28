require 'spec_helper'
require 'social_blast'

describe SocialBlast::Services do
  before do
    SocialBlast::Services.stub(:constants).and_return([:TwitterService, :SomeString])

    twitter_service_class = double('TwitterService')
    twitter_service_class.stub(:class).and_return(Class)
    SocialBlast::Services.stub(:const_get).with(:TwitterService).and_return(twitter_service_class)

    some_string_class = double('Some String')
    twitter_service_class.stub(:class).and_return(Class)
    SocialBlast::Services.stub(:const_get).with(:SomeString).and_return(some_string_class)
  end

  subject { SocialBlast::Services }

  its(:services_available) { should include(:TwitterService) }
  its(:services_available) { should_not include(:SomeString) }
end

