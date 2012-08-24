require 'spec_helper'

describe SocialBlast::Services::Twitter do
  subject { SocialBlast::Services::Twitter }

  its(:config) { should be_kind_of(Hashie::Mash) }

  context "when configured" do
    SocialBlast::Services::Twitter.config { |c| c.username = 'foo', c.api_key = '2sh38an' }
    SocialBlast::Services::Twitter.configured?.should be_true
  end

  context "when not configured" do
    SocialBlast::Services::Twitter.config { |c| c.username = nil, c.api_key = nil }
    SocialBlast::Services::Twitter.configured?.should_not be_true
  end

  context "when initialized" do
    it "has a name"
    it "has a message"
  end

  context "when delivering" do
    it "returns true if successful"
    it "raises an exception if not successful"
  end
end

