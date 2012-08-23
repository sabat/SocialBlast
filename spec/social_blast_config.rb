require 'spec_helper'

describe SocialBlast do
  context "config method" do
    subject { SocialBlast }
    its(:config) { should be_a_kind_of(SocialBlast::Configuration) }
    its(:config) { should be_a_kind_of(Hashie::Mash) }

    it "yields to a block if given" do
      expect { |b| SocialBlast.config(&b) }.to yield_control
    end
  end
end

