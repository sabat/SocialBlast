require 'spec_helper'

describe SocialBlast do
  context "class level" do
    subject { SocialBlast }
    its(:config) { should be_a_kind_of(SocialBlast::Configuration) }
  end
end

