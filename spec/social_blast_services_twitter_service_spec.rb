require 'spec_helper'

describe SocialBlast::Services::TwitterService do
  let(:valid_config) do
    SocialBlast.configure do |c|
      t = c[:twitter]
      t.consumer_key = '7wehnkjfhsd'
      t.consumer_secret = 'sdflkh'
      t.oauth_token = 's987yhksdjf8234h2n'
      t.oauth_token_secret = 's098uhnnerf9fussdfs3'
    end
  end
  subject { SocialBlast::Services::TwitterService }

  its(:service_name) { should eq(:TwitterService) }
  it { should respond_to(:service_auth_keywords) }

  context "when configured" do
    before { valid_config }
    its(:configured?) { should be_true }
  end

  context "when not configured" do
    before do
      SocialBlast.configure { |c| c.twitter.consumer_secret = nil }
    end
    its(:configured?) { should_not be_true }
  end

  context "when initialized" do
    before { valid_config }
    subject { SocialBlast::Services::TwitterService.new('a message') }

    its(:message) { should_not be_blank }
    its(:service_name) { should eq(:TwitterService) }
    its(:short_name) { should eq('twitter') }
    its(:short_name_sym) { should eq(:twitter) }
  end

  context "when delivering" do
    let(:tweet) { mock(Twitter::Tweet) }
    before { valid_config }
    subject(:twitter_instance) { SocialBlast::Services::TwitterService.new('a message') }

    it "returns without error if successful" do
      Twitter::Client.any_instance.should_receive(:update)
      expect { twitter_instance.deliver }.to_not raise_error
    end

    it "raises an exception if not successful" do
      Twitter::Client.any_instance.should_receive(:update).and_raise(Twitter::Error)
      expect { twitter_instance.deliver }.to raise_error(DeliveryException)
    end
  end
end

