require 'spec_helper'

describe SocialBlast::Services::Twitter do
  subject { SocialBlast::Services::Twitter }

  its(:service_name) { should eq(:Twitter) }
  its(:configure) { should be_kind_of(Hashie::Mash) }

  context "when configured" do
    SocialBlast::Services::Twitter.configure do |c|
      c.consumer_key = '7wehnkjfhsd'
      c.consumer_secret = 'sdflkh'
      c.oauth_token = 's987yhksdjf8234h2n'
      c.oauth_token_secret = 's098uhnnerf9fussdfs3'
    end

    its(:configured?) { should be_true }
  end

  context "when not configured" do
    SocialBlast::Services::Twitter.configure { |c| c.username = nil, c.api_key = nil }
    its(:configured?) { should_not be_true }
  end

  context "when initialized" do
    subject { SocialBlast::Services::Twitter.new('a message') }
    its(:service_name) { should eq(:Twitter) }
    its(:message) { should_not be_blank }
  end

  context "when delivering" do
    it "returns true if successful"
    it "raises an exception if not successful"
  end
end

