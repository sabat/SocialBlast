require 'spec_helper'

describe SocialBlast::Services::BufferService do
  let(:valid_config) do
    SocialBlast.configure do |c|
      t = c[:buffer]
      t.access_token = '3/23ohw083947bsdkjfh'
    end
  end
  subject { SocialBlast::Services::BufferService }

  its(:service_name) { should eq(:BufferService) }
  it { should respond_to(:service_auth_keywords) }

  context "when configured" do
    before { valid_config }
    its(:configured?) { should be_true }
  end

  context "when not configured" do
    before do
      SocialBlast.configure { |c| c.buffer.access_token = nil }
    end
    its(:configured?) { should_not be_true }
  end

  context "when initialized" do
    before { valid_config }
    subject { SocialBlast::Services::BufferService.new('a message') }

    its(:message) { should_not be_blank }
    its(:service_name) { should eq(:BufferService) }
    its(:short_name) { should eq('buffer') }
    its(:short_name_sym) { should eq(:buffer) }
  end

  context "when delivering" do
    let!(:buff_client) { double(Buff::Client) }
    let!(:profile_id) { [ Hashie::Mash.new({ id: '203948sd232' }) ] }
    before { valid_config }
    subject(:buff_client) { SocialBlast::Services::BufferService.new('a message') }

    it "returns without error if successful" do
      Buff::Client.any_instance.should_receive(:profiles).and_return(profile_id)
      Buff::Client.any_instance.should_receive(:create_update)
      expect { buff_client.deliver }.to_not raise_error
    end

    it "raises an exception if profiles request is not successful" do
      Buff::Client.any_instance.should_receive(:profiles).and_raise(Exception)
      Buff::Client.any_instance.should_not_receive(:create_update)
      expect { buff_client.deliver }.to raise_error(Exception)
    end

    it "raises an exception if delivery is not successful" do
      Buff::Client.any_instance.should_receive(:profiles).and_return(profile_id)
      Buff::Client.any_instance.should_receive(:create_update).and_raise(Exception)
      expect { buff_client.deliver }.to raise_error(Exception)
    end
  end
end

