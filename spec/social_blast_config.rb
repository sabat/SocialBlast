require 'spec_helper'

describe SocialBlast do
  context "config method" do
    subject { SocialBlast }
    its(:configure) { should be_a_kind_of(SocialBlast::Configuration) }
    its(:configure) { should be_a_kind_of(Hashie::Mash) }

    it "yields to a block if given" do
      expect { |b| SocialBlast.configure(&b) }.to yield_control
    end
  end
end

