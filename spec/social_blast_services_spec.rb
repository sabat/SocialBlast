require 'spec_helper'
require 'social_blast'

describe SocialBlast::Services do
  before do
    SocialBlast::Services.stub(:constants).and_return([:TwitterService, :SomeString])

    twitter_service_class = double('TwitterService')
    twitter_service_class.stub(:class).and_return(Class)
    twitter_service_class.stub(:short_name_sym).and_return(:twitter)
    SocialBlast::Services.stub(:const_get).with(:TwitterService).and_return(twitter_service_class)

    some_string_class = double('Some String')
    some_string_class.stub(:class).and_return(String)
    SocialBlast::Services.stub(:const_get).with(:SomeString).and_return(some_string_class)
  end

  subject { SocialBlast::Services }

  its(:services_available) { should include(:TwitterService) }
  its(:services_available) { should_not include(:SomeString) }

  context "services_available with the :short argument" do
    subject { SocialBlast::Services.services_available(:short) }
    it { should eq([:twitter]) }
  end
end

